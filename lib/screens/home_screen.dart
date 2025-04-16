import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/screens/favorites_screen.dart';
import 'package:singify/screens/genres_screen.dart';
import 'package:singify/screens/genre_details_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/profile_screen.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/featured_song_card.dart';
import 'package:singify/widgets/genre_card.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:singify/widgets/popular_lyric_card.dart';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // Return the child directly without any transition animation
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const FavoritesScreen(),
  ];

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
                    Text(
                      'Singify',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: const Color(0xFF8b2cf5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF666666)),
                        onPressed: () {
                          // Add haptic feedback
                          HapticFeedback.selectionClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        splashColor: const Color(0xFF8b2cf5).withOpacity(0.2),
                        highlightColor: const Color(0xFF8b2cf5).withOpacity(0.1),
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
              child: _screens[_currentIndex],
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
                        // Add haptic feedback
                        HapticFeedback.selectionClick();
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
                    NavItem(
                      icon: Icons.explore,
                      label: 'Explore',
                      isSelected: false,
                      onTap: () {
                        // Add haptic feedback
                        HapticFeedback.selectionClick();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.favorite,
                      label: 'Favorite',
                      isSelected: _currentIndex == 1,
                      onTap: () {
                        // Add haptic feedback
                        HapticFeedback.selectionClick();
                        setState(() {
                          _currentIndex = 1;
                        });
                        // No animation needed as it's switching tabs in the same screen
                      },
                    ),
                    NavItem(
                      icon: Icons.person,
                      label: 'Profile',
                      isSelected: false,
                      onTap: () {
                        // Add haptic feedback
                        HapticFeedback.selectionClick();
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

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Featured genres with their colors
    final List<Map<String, dynamic>> featuredGenres = [
      {'name': 'Pop', 'color': const Color(0xFF8b2cf5), 'songs': '1.2M'},
      {'name': 'Rock', 'color': const Color(0xFFe63946), 'songs': '1.2M'},
    ];

    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        // Featured Songs
        const Text(
          'Featured Songs',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF282828),
          ),
        ),
        const SizedBox(height: 20),
        ...featuredSongs.map((song) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FeaturedSongCard(song: song),
          );
        }).toList(),
        
        const SizedBox(height: 30),
        
        // Featured Genres - New section based on Figma design
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Genres',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF282828),
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenresScreen()),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF8b2cf5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Featured Genres Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: featuredGenres.map((genre) {
            return _buildFeaturedGenreCard(
              context,
              genre['name'],
              genre['songs'],
              genre['color'],
            );
          }).toList(),
        ),
        
        const SizedBox(height: 30),
        
        // Popular Lyrics
        const Text(
          'Popular Lyrics',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF282828),
          ),
        ),
        const SizedBox(height: 20),
        ...popularLyrics.map((song) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: PopularLyricCard(song: song),
          );
        }).toList(),
        
        const SizedBox(height: 30),
        
        // Browse by Genre - Original section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Browse by Genre',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF282828),
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenresScreen()),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF8b2cf5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Genre Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.5,
          children: genres.map((genre) => GenreCard(genre: genre)).toList(),
        ),
        
        const SizedBox(height: 20), // Bottom padding
      ],
    );
  }
  
  Widget _buildFeaturedGenreCard(BuildContext context, String name, String songs, Color color) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenreDetailsScreen(
                genre: name,
                color: color,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$songs Songs',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
