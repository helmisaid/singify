import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/screens/home_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/favorites_screen.dart';
import 'package:singify/screens/profile_screen.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final isFavorite = favoritesService.isFavorite(widget.song.id);

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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        print("Back button pressed");
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Now Playing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      
                      // Album Art with purple music note
                      Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05), // Reduced opacity
                              blurRadius: 5, // Reduced blur
                              offset: const Offset(0, 2), // Smaller offset
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.music_note,
                            size: 80,
                            color: const Color(0xFF8b2cf5), // Purple color to match your icon
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Song Info
                      Text(
                        widget.song.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF282828), // Darker text
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.song.artist,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666), // Darker text
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Play Button (display only)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2), // Reduced opacity
                              blurRadius: 6, // Reduced blur
                              offset: const Offset(0, 2), // Smaller offset
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Favorite button
                          Material(
                            color: isFavorite ? const Color(0xFF8b2cf5) : Colors.white,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () {
                                print("Favorite button pressed");
                                HapticFeedback.mediumImpact();
                                favoritesService.toggleFavorite(widget.song);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite ? 'Removed from favorites' : 'Added to favorites'
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.white : const Color(0xFF8b2cf5),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Add button
                          Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                print("Add button pressed");
                                HapticFeedback.mediumImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Add to playlist feature coming soon'),
                                    duration: Duration(seconds: 1),
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
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Share button
                          Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                print("Share button pressed");
                                HapticFeedback.mediumImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Share feature coming soon'),
                                    duration: Duration(seconds: 1),
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
                                child: const Icon(
                                  Icons.share,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Lyrics Section
                      if (widget.song.lyrics != null) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lyrics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF282828), // Darker text
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            widget.song.lyrics!,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Color(0xFF282828), // Darker text
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                      
                      // Similar Songs Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Similar Songs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF282828), // Darker text
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Similar song items
                      _buildSimilarSongItem(
                        context,
                        'Shape Of You',
                        'Ed Sheeran',
                        'assets/images/album_covers/shape_of_you.jpg',
                      ),
                      const SizedBox(height: 12),
                      _buildSimilarSongItem(
                        context,
                        'Perfect',
                        'Ed Sheeran',
                        'assets/images/album_covers/perfect.jpg',
                      ),
                      
                      const SizedBox(height: 80), // Bottom padding for scrolling
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
                        Navigator.push(
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
                        // Navigate to favorites screen
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            builder: (context) => const FavoritesScreen(showFullScreen: true),
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
  
  Widget _buildSimilarSongItem(BuildContext context, String title, String artist, String albumArt) {
    return Material(
      color: const Color(0xFFeeeeee),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          print("Similar song item pressed: $title");
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: $title by $artist'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 64,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.asset(
                  albumArt,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, size: 30),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF282828), // Darker text
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artist,
                      style: const TextStyle(
                        color: Color(0xFF666666), // Darker text
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
