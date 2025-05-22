import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/services/pocketbase_service.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int _currentIndex = 0;
  late Song song;
  late bool isFavorite;
  double _currentSliderValue = 0;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PocketBaseService _pbService = PocketBaseService();
  bool _isLoading = true;
  String _errorMessage = '';
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    
    // Set up audio player listeners
    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing != _isPlaying) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
        if (_duration.inMilliseconds > 0) {
          _currentSliderValue = position.inMilliseconds / _duration.inMilliseconds * 100;
        }
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get song from arguments when first built
    final args = ModalRoute.of(context)?.settings.arguments as Song?;
    if (args != null) {
      song = args;
      final favoritesService = Provider.of<FavoritesService>(context);
      isFavorite = favoritesService.isFavorite(song.id);
      
      // Load and play the song
      _loadSong();
    }
  }

  Future<void> _loadSong() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Construct the URL to the song file using the simplified method
      final songUrl = _pbService.getSongFileUrl(
        song.collectionId,
        song.id,
        song.songFile,
      );
      
      // Load and play the audio
      await _audioPlayer.setUrl(songUrl);
      await _audioPlayer.play();
      
      // Increment play count
      await _pbService.incrementPlayCount(song.id);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load song: $e';
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    // Update isFavorite when building to stay in sync
    isFavorite = favoritesService.isFavorite(song.id);
    final size = MediaQuery.of(context).size;

    // Get album art URL using the simplified method
    final albumArtUrl = _pbService.getSongImageUrl(
      song.collectionId,
      song.id,
      song.songImage,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with down arrow and options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'NOW PLAYING',
                    style: TextStyle(
                      color: Color(0xFF282828),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onPressed: () {
                      // Show options menu
                    },
                  ),
                ],
              ),
            ),
            
            // Divider for visual separation
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            
            // Main content area - Spotify style layout
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8b2cf5)),
                          ),
                        )
                      else if (_errorMessage.isNotEmpty)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadSong,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8b2cf5),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        // Album art - large and centered like Spotify
                        Hero(
                          tag: 'album-art-${song.id}',
                          child: Container(
                            width: size.width * 0.8,
                            height: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                albumArtUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.music_note,
                                      size: 100,
                                      color: const Color(0xFF8b2cf5),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Song info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.title,
                                    style: const TextStyle(
                                      color: Color(0xFF282828),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    song.artistName,
                                    style: const TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? const Color(0xFF8b2cf5) : Colors.grey,
                                size: 24,
                              ),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                favoritesService.toggleFavorite(song);
                                setState(() {
                                  isFavorite = favoritesService.isFavorite(song.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite ? 'Added to favorites' : 'Removed from favorites'
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Progress bar - Spotify style
                        Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14,
                                ),
                                activeTrackColor: const Color(0xFF8b2cf5),
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: const Color(0xFF8b2cf5),
                                overlayColor: const Color(0xFF8b2cf5).withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _currentSliderValue.clamp(0, 100),
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _currentSliderValue = value;
                                  });
                                },
                                onChangeEnd: (double value) {
                                  final newPosition = Duration(
                                    milliseconds: (value / 100 * _duration.inMilliseconds).round(),
                                  );
                                  _audioPlayer.seek(newPosition);
                                },
                              ),
                            ),
                            
                            // Time indicators
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_position),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(_duration),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Playback controls - Spotify style layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.shuffle, color: Colors.grey[700], size: 24),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_previous, color: Colors.grey[800], size: 36),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                // Previous song functionality
                              },
                            ),
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor, // Using your primary color
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  if (_isPlaying) {
                                    _audioPlayer.pause();
                                  } else {
                                    _audioPlayer.play();
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next, color: Colors.grey[800], size: 36),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                // Next song functionality
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.repeat, color: Colors.grey[700], size: 24),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Bottom action row - Spotify style
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              Icons.devices,
                              'Connect to a device feature coming soon',
                              context,
                            ),
                            _buildActionButton(
                              Icons.playlist_add,
                              'Add to playlist feature coming soon',
                              context,
                            ),
                            _buildActionButton(
                              Icons.share,
                              'Share feature coming soon',
                              context,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Lyrics section (if available) - collapsed by default in Spotify
                        if (song.lyrics != null) ...[
                          InkWell(
                            onTap: () {
                              // Toggle lyrics visibility
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Full lyrics view coming soon'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lyrics,
                                    color: Color(0xFF8b2cf5),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'LYRICS',
                                      style: TextStyle(
                                        color: Color(0xFF282828),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                      
                      const SizedBox(height: 80), // Bottom padding for scrolling
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation - keeping your original navigation
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavItem(
                      icon: Icons.home,
                      label: 'Home',
                      isSelected: _currentIndex == 0,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.explore,
                      label: 'Explore',
                      isSelected: _currentIndex == 1,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                    NavItem(
                      icon: Icons.favorite,
                      label: 'Favorite',
                      isSelected: _currentIndex == 2,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(
                          context,
                          '/favorites',
                          arguments: {'showFullScreen': true},
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.person,
                      label: 'Profile',
                      isSelected: _currentIndex == 3,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String message, BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}