import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/screens/home_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/profile_screen.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:singify/widgets/popular_lyric_card.dart';

class FavoritesScreen extends StatefulWidget {
  final bool showFullScreen;
  
  const FavoritesScreen({
    Key? key, 
    this.showFullScreen = false,
  }) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final int _currentIndex = 2; // Favorites tab selected
  
  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final favoriteSongs = favoritesService.favoriteSongs;

    // If not showing as full screen, just return the content
    if (!widget.showFullScreen) {
      return _buildContent(favoriteSongs);
    }
    
    // Otherwise, return a full scaffold with navigation
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
              child: _buildContent(favoriteSongs),
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
                        // Navigate to home screen
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                        // Navigate to search/explore screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.favorite,
                      label: 'Favorite',
                      isSelected: _currentIndex == 2,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        // Already on favorites screen
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
                          MaterialPageRoute(
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
  
  Widget _buildContent(List<Song> favoriteSongs) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Favorites',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF282828), // Darker text
            ),
          ),
          const SizedBox(height: 15),
          
          Expanded(
            child: favoriteSongs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No favorite songs yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666), // Darker text
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tap the heart icon on any song to add it to your favorites',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666), // Darker text
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: favoriteSongs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: PopularLyricCard(song: favoriteSongs[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
