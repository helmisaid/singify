import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/genre_model.dart';
import 'package:singify/screens/genre_details_screen.dart';

class GenreCard extends StatelessWidget {
  final Genre genre;
  
  const GenreCard({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map genre names to colors
    final Map<String, Color> genreColors = {
      'Pop': const Color(0xFF8b2cf5),
      'Rock': const Color(0xFFe63946),
      'Hip Hop': const Color(0xFF3985ff),
      'R&B': const Color(0xFFf9844a),
      'Jazz': const Color(0xFF2a9d8f),
      'Classical': const Color(0xFF457b9d),
      'Electronic': const Color(0xFFf4a261),
      'Country': const Color(0xFF6d6875),
    };
    
    // Get color for this genre or use a default
    final color = genreColors[genre.name] ?? const Color(0xFF8b2cf5);
    
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenreDetailsScreen(
                genre: genre.name,
                color: color,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                genre.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${genre.songCount} songs',
                style: TextStyle(
                  fontSize: 12,
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
