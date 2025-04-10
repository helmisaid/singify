import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/genre_model.dart';
import 'package:singify/screens/genre_details_screen.dart';
import 'package:singify/screens/home_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/favorites_screen.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  int _currentIndex = 0;

  // Featured genres with their colors
  final List<Map<String, dynamic>> _featuredGenres = [
    {'name': 'Pop', 'color': const Color(0xFF8b2cf5), 'songs': '1.2M Songs'},
    {'name': 'Rock', 'color': const Color(0xFFe63946), 'songs': '1.2M Songs'},
    {
      'name': 'Hip Hop',
      'color': const Color(0xFF3985ff),
      'songs': '1.2M Songs'
    },
    {'name': 'R&B', 'color': const Color(0xFFf9844a), 'songs': '1.2M Songs'},
  ];

  // All genres list
  final List<Map<String, dynamic>> _allGenres = [
    {
      'name': 'Hip Hop',
      'color': const Color(0xFF3985ff),
      'songs': '1.2M Songs'
    },
    {'name': 'Jazz', 'color': const Color(0xFF3985ff), 'songs': '1.2M Songs'},
    {
      'name': 'Classical',
      'color': const Color(0xFF3985ff),
      'songs': '1.2M Songs'
    },
    {
      'name': 'Electronic',
      'color': const Color(0xFF3985ff),
      'songs': '1.2M Songs'
    },
    {
      'name': 'Country',
      'color': const Color(0xFF3985ff),
      'songs': '1.2M Songs'
    },
    {'name': 'Blues', 'color': const Color(0xFF3985ff), 'songs': '1.2M Songs'},
    {'name': 'Reggae', 'color': const Color(0xFF3985ff), 'songs': '1.2M Songs'},
    {'name': 'Folk', 'color': const Color(0xFF3985ff), 'songs': '1.2M Songs'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeeeee),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with white background
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Singify',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: const Color(0xFF8b2cf5),
                                fontWeight: FontWeight.bold,
                              ),
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Featured Genres',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF282828),
                        ),
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
                        children: _featuredGenres.map((genre) {
                          return _buildFeaturedGenreCard(
                            genre['name'],
                            genre['songs'],
                            genre['color'],
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'All Genres',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF282828),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // All Genres List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _allGenres.length,
                        itemBuilder: (context, index) {
                          return _buildGenreListItem(
                            _allGenres[index]['name'],
                            _allGenres[index]['songs'],
                            _allGenres[index]['color'],
                          );
                        },
                      ),
                    ],
                  ),
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
                          MaterialPageRoute(
                            builder: (context) =>
                                const FavoritesScreen(showFullScreen: true),
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

  Widget _buildFeaturedGenreCard(String name, String songs, Color color) {
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
                songs,
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

  Widget _buildGenreListItem(String name, String songs, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF282828),
                        ),
                      ),
                      Text(
                        songs,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF666666),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
