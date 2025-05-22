import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/pocketbase_service.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:singify/widgets/featured_song_card.dart';
import 'package:pocketbase/pocketbase.dart';

class GenreDetailsScreen extends StatefulWidget {
  const GenreDetailsScreen({Key? key}) : super(key: key);

  @override
  State<GenreDetailsScreen> createState() => _GenreDetailsScreenState();
}

class _GenreDetailsScreenState extends State<GenreDetailsScreen> {
  int _currentIndex = 0;
  final PocketBaseService _pbService = PocketBaseService();
  List<Song> _genreSongs = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late String _genreId;
  late String _genreName;
  late Color _color;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _genreId = args['genreId'] as String;
      _genreName = args['genreName'] as String;
      _color = args['color'] as Color;
      _fetchSongs();
    }
  }

  Future<void> _fetchSongs() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final records = await _pbService.getSongsByGenre(_genreId);
      final songs = records.map((record) => Song.fromRecord(record)).toList();

      setState(() {
        _genreSongs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load songs: $e';
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

            // Genre Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: _color.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _genreName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLoading 
                      ? 'Loading songs...' 
                      : '${_genreSongs.length} Songs',
                    style: TextStyle(
                      fontSize: 16,
                      color: _color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content - Song List
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
                            onPressed: _fetchSongs,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8b2cf5),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _genreSongs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_off,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No songs found in $_genreName',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Popular in $_genreName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF282828),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _genreSongs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: FeaturedSongCard(song: _genreSongs[index]),
                                  );
                                },
                              ),
                            ),
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