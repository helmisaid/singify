import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/genre_model.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/pocketbase_service.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/featured_song_card.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final PocketBaseService _pbService = PocketBaseService();
  List<Song> _featuredSongs = [];
  List<Genre> _genres = [];
  bool _isLoadingSongs = true;
  bool _isLoadingGenres = true;
  String _songsErrorMessage = '';
  String _genresErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFeaturedSongs();
    _fetchGenres();
  }

  Future<void> _fetchFeaturedSongs() async {
    try {
      setState(() {
        _isLoadingSongs = true;
        _songsErrorMessage = '';
      });

      // Make sure to use the items from the result
      final records = await _pbService.getFeaturedSongs(limit: 5);

      // Now map each record to a Song object
      final songs = records.map((record) => Song.fromRecord(record)).toList();

      setState(() {
        _featuredSongs = songs;
        _isLoadingSongs = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSongs = false;
        _songsErrorMessage = 'Failed to load featured songs: $e';
      });
    }
  }

  // Replace your _fetchGenres method with this:

  Future<void> _fetchGenres() async {
    try {
      setState(() {
        _isLoadingGenres = true;
        _genresErrorMessage = '';
      });

      final genres = await _pbService.getAllGenresWithSongCount();

      setState(() {
        _genres = genres;
        _isLoadingGenres = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingGenres = false;
        _genresErrorMessage = 'Failed to load genres: $e';
      });
    }
  }

// And update your genre card building code:

  Widget _buildFeaturedGenreCard(
      BuildContext context, Genre genre, Color color, IconData icon) {
    return Material(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamed(
              context,
              '/genre_details',
              arguments: {
                'genreId': genre.id,
                'genreName': genre.name,
                'color': color
              },
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      genre.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${genre.songCount} songs',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.wait([
      _fetchFeaturedSongs(),
      _fetchGenres(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Define genre colors map
    final Map<String, Color> genreColors = {
      'Pop': const Color(0xFF8b2cf5),
      'Rock': const Color(0xFFe63946),
      'Hip Hop': const Color(0xFF2a9d8f),
      'Jazz': const Color(0xFFe9c46a),
      'Electronic': const Color(0xFF00b4d8),
      'R&B': const Color(0xFFf4a261),
      'Country': const Color(0xFF588157),
      'Classical': const Color(0xFF457b9d),
      'Metal': const Color(0xFF6d6875),
      'Folk': const Color(0xFFbc6c25),
    };

    // Define genre icons map
    final Map<String, IconData> genreIcons = {
      'Pop': Icons.music_note,
      'Rock': Icons.music_note,
      'Hip Hop': Icons.headphones,
      'Jazz': Icons.piano,
      'Electronic': Icons.equalizer,
      'R&B': Icons.queue_music,
      'Country': Icons.music_note,
      'Classical': Icons.music_note,
      'Metal': Icons.music_note,
      'Folk': Icons.music_note,
    };

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFF8b2cf5),
      child: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          // Welcome message
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8b2cf5).withOpacity(0.8),
                  const Color(0xFFa64efd).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good ${_getTimeOfDay()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Discover new music',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Featured Songs with enhanced header
          _buildSectionHeader('Featured Songs', onSeeAllPressed: () {
            Navigator.pushNamed(context, '/featured');
          }),
          const SizedBox(height: 16),

          // Featured songs list with loading state
          if (_isLoadingSongs)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8b2cf5)),
                ),
              ),
            )
          else if (_songsErrorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      _songsErrorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchFeaturedSongs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8b2cf5),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_featuredSongs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No featured songs available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Column(
              children: _featuredSongs
                  .map((song) => FeaturedSongCard(song: song))
                  .toList(),
            ),

          const SizedBox(height: 32),

          // Featured Genres section
          _buildSectionHeader('Featured Genres', onSeeAllPressed: () {
            Navigator.pushNamed(context, '/genres');
          }),
          const SizedBox(height: 16),

          // Featured Genres Grid with loading state
          // Update the genres grid section in your home_content.dart file:

// Featured Genres Grid with loading state
          if (_isLoadingGenres)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8b2cf5)),
                ),
              ),
            )
          else if (_genresErrorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      _genresErrorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchGenres,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8b2cf5),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_genres.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No genres available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: _genres.length > 4
                  ? 4
                  : _genres.length, // Show max 4 genres on home screen
              itemBuilder: (context, index) {
                final genre = _genres[index];
                return _buildGenreCard(context, genre);
              },
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF282828),
          ),
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8b2cf5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

// Replace the _buildFeaturedGenreCard method with this:
  Widget _buildGenreCard(BuildContext context, Genre genre) {
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

    // Map genre names to icons
    final Map<String, IconData> genreIcons = {
      'Pop': Icons.music_note,
      'Rock': Icons.music_note,
      'Hip Hop': Icons.headphones,
      'Jazz': Icons.piano,
      'Electronic': Icons.equalizer,
      'R&B': Icons.queue_music,
      'Country': Icons.music_note,
      'Classical': Icons.music_note,
      'Metal': Icons.music_note,
      'Folk': Icons.music_note,
    };

    // Get color for this genre or use a default
    final color = genreColors[genre.name] ?? const Color(0xFF8b2cf5);
    // Get icon for this genre or use a default
    final icon = genreIcons[genre.name] ?? Icons.music_note;

    return Material(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamed(
              context,
              '/genre_details',
              arguments: {
                'genreId': genre.id,
                'genreName': genre.name,
                'color': color
              },
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      genre.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${genre.songCount} songs',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }
}
