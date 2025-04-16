import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/screens/home_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/favorites_screen.dart';
import 'package:singify/screens/profile_screen.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:singify/widgets/popular_lyric_card.dart';

class GenreDetailsScreen extends StatefulWidget {
  final String genre;
  final Color color;

  const GenreDetailsScreen({
    Key? key,
    required this.genre,
    required this.color,
  }) : super(key: key);

  @override
  State<GenreDetailsScreen> createState() => _GenreDetailsScreenState();
}

class _GenreDetailsScreenState extends State<GenreDetailsScreen> {
  int _currentIndex = 0;
  late List<Song> _genreSongs;

  @override
  void initState() {
    super.initState();

    // Filter songs by genre
    _genreSongs = [...featuredSongs, ...popularLyrics].where((song) {
      return song.genre.toLowerCase() == widget.genre.toLowerCase();
    }).toList();

    // If no songs match the genre, add some placeholder songs
    if (_genreSongs.isEmpty) {
      _genreSongs = [
        Song(
          id: 'g1',
          title: '${widget.genre} Hit 1',
          artist: 'Various Artists',
          albumArt: 'assets/images/album_covers/default.jpg',
          genre: widget.genre,
        ),
        Song(
          id: 'g2',
          title: '${widget.genre} Hit 2',
          artist: 'Top ${widget.genre} Artist',
          albumArt: 'assets/images/album_covers/default.jpg',
          genre: widget.genre,
        ),
        Song(
          id: 'g3',
          title: 'Best of ${widget.genre}',
          artist: 'Various Artists',
          albumArt: 'assets/images/album_covers/default.jpg',
          genre: widget.genre,
        ),
      ];
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
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
              color: widget.color.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.genre,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_genreSongs.length} Songs',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content - Song List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular in ${widget.genre}',
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
                            child: PopularLyricCard(song: _genreSongs[index]),
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()),
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.favorite,
                      label: 'Favorite',
                      isSelected: _currentIndex == 2,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            builder: (context) =>
                                const FavoritesScreen(showFullScreen: true),
                          ),
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.person,
                      label: 'Profile',
                      isSelected: _currentIndex == 3,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        // Navigate to profile screen
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
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
