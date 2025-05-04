import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/utils/constants.dart';

class FeaturedSongCard extends StatelessWidget {
  final Song song;

  const FeaturedSongCard({
    Key? key,
    required this.song,
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
        onTap: () {
          print("Featured song card tapped: ${song.title}");
          Navigator.pushNamed(
            context,
            '/player',
            arguments: song,
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16), // Slightly increased padding
          child: Row(
            children: [
              Hero(
                tag: 'album-art-${song.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    song.albumArt,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16), // Increased spacing
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
                    const SizedBox(height: 6), // Added spacing
                    Text(
                      song.artist,
                      style: subtitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16), // Increased spacing
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            print("Play Now button pressed: ${song.title}");
                            Navigator.pushNamed(
                              context,
                              '/player',
                              arguments: song,
                            );
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            size: 20,
                            color: Colors.white, // Mengubah warna icon play menjadi putih
                          ),
                          label: const Text('Play Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 24,
                          ),
                          onPressed: () {
                            favoritesService.toggleFavorite(song);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isFavorite
                                    ? 'Removed from favorites'
                                    : 'Added to favorites'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
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