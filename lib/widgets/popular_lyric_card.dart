import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/utils/constants.dart';

class PopularLyricCard extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;

  const PopularLyricCard({
    Key? key,
    required this.song,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final isFavorite = favoritesService.isFavorite(song.id);

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(15),
      elevation: 1, // Reduced elevation for more modern look
      child: InkWell(
        onTap: onTap ??
            () {
              print("Popular lyric card tapped: ${song.title}");
              Navigator.pushNamed(
                context,
                '/player',
                arguments: song,
              );
            },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16), // Increased padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8), // Increased spacing
                    Text(
                      song.artist,
                      style: subtitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Play button
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: primaryColor,
                        size: 32, // Slightly larger
                      ),
                      onPressed: onTap ??
                          () {
                            print("Play button pressed: ${song.title}");
                            Navigator.pushNamed(
                              context,
                              '/player',
                              arguments: song,
                            );
                          },
                      splashRadius: 24,
                      padding: const EdgeInsets.all(8), // Added padding
                    ),
                  ),
                  // Favorite button
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        print("Favorite button pressed: ${song.title}");
                        favoritesService.toggleFavorite(song);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite ? 'Removed from favorites' : 'Added to favorites'
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      splashRadius: 24,
                      padding: const EdgeInsets.all(8), // Added padding
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}