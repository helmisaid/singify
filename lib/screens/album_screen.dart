import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/album_model.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/pocketbase_service.dart';
import 'package:singify/widgets/featured_song_card.dart';
import 'package:singify/widgets/nav_item.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final PocketBaseService _pbService = PocketBaseService();
  Album? _album;
  List<Song> _songs = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late String _albumId;
  int _currentIndex = 1; // Explore tab selected

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _albumId = args['albumId'] as String;
      _fetchAlbumData();
    }
  }

  Future<void> _fetchAlbumData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Fetch album details
      final album = await _pbService.getAlbumById(_albumId);
      
      if (album == null) {
        throw Exception('Album not found');
      }

      // Fetch album's songs
      final songRecords = await _pbService.getSongsByAlbum(_albumId);
      final songs = songRecords.map((record) => Song.fromRecord(record)).toList();

      setState(() {
        _album = album;
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load album data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Standardized App Bar with consistent height and padding
            Container(
              color: Colors.white,
              height: 60, // Fixed height for consistency
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color(0xFF666666)),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Singify',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: const Color(0xFF8b2cf5),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        icon:
                            const Icon(Icons.search, color: Color(0xFF666666)),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          Navigator.pushNamed(context, '/search');
                        },
                        splashColor: const Color(0xFF8b2cf5).withOpacity(0.2),
                        highlightColor:
                            const Color(0xFF8b2cf5).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider for visual separation
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),

            // Main Content
            Expanded(
              child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8b2cf5)),
                    ),
                  )
                : _errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchAlbumData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8b2cf5),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _album == null
                    ? const Center(
                        child: Text('Album not found'),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Album Header
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              color: const Color(0xFF8b2cf5).withOpacity(0.1),
                              child: Row(
                                children: [
                                  // Album Cover
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _album!.coverImage.isNotEmpty
                                      ? Image.network(
                                          _pbService.getAlbumCoverUrl(
                                            _album!.collectionId,
                                            _album!.id,
                                            _album!.coverImage,
                                          ),
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.album,
                                                color: Color(0xFF8b2cf5),
                                                size: 50,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 120,
                                          height: 120,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.album,
                                            color: Color(0xFF8b2cf5),
                                            size: 50,
                                          ),
                                        ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Album Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _album!.title,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF282828),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        if (_album!.artistName != null)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/artist',
                                                arguments: {'artistId': _album!.artistId},
                                              );
                                            },
                                            child: Text(
                                              _album!.artistName!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF8b2cf5),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${_songs.length} Songs • ${_album!.releaseDate.year}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Play Buttons
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Play all songs
                                      if (_songs.isNotEmpty) {
                                        Navigator.pushNamed(
                                          context,
                                          '/player',
                                          arguments: _songs[0],
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.play_arrow),
                                    label: const Text('Play All'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8b2cf5),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // Shuffle functionality
                                      if (_songs.isNotEmpty) {
                                        _songs.shuffle();
                                        Navigator.pushNamed(
                                          context,
                                          '/player',
                                          arguments: _songs[0],
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.shuffle),
                                    label: const Text('Shuffle'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF8b2cf5),
                                      side: const BorderSide(color: Color(0xFF8b2cf5)),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Songs Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Songs',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF282828),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  _songs.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'No songs available',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: _songs.map((song) => 
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: FeaturedSongCard(song: song),
                                          )
                                        ).toList(),
                                      ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
            ),

            // Bottom Navigation
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
}