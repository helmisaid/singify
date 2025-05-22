import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/album_model.dart';
import 'package:singify/models/artist_model.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/services/pocketbase_service.dart';
import 'package:singify/widgets/featured_song_card.dart';
import 'package:singify/widgets/nav_item.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({Key? key}) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  final PocketBaseService _pbService = PocketBaseService();
  Artist? _artist;
  List<Song> _songs = [];
  List<Album> _albums = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late String _artistId;
  int _currentIndex = 1; // Explore tab selected

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _artistId = args['artistId'] as String;
      _fetchArtistData();
    }
  }

  Future<void> _fetchArtistData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Fetch artist details
      final artist = await _pbService.getArtistById(_artistId);
      
      if (artist == null) {
        throw Exception('Artist not found');
      }

      // Fetch artist's songs
      final songRecords = await _pbService.getSongsByArtist(_artistId);
      final songs = songRecords.map((record) => Song.fromRecord(record)).toList();

      // Fetch artist's albums
      final albums = await _pbService.getAlbumsByArtist(_artistId);

      setState(() {
        _artist = artist;
        _songs = songs;
        _albums = albums;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load artist data: $e';
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

            // Main Content
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
                            onPressed: _fetchArtistData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8b2cf5),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _artist == null
                    ? const Center(
                        child: Text('Artist not found'),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Artist Header
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              color: const Color(0xFF8b2cf5).withOpacity(0.1),
                              child: Row(
                                children: [
                                  // Artist Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: _artist!.profilePicture.isNotEmpty
                                      ? Image.network(
                                          _pbService.getArtistImageUrl(
                                            _artist!.collectionId,
                                            _artist!.id,
                                            _artist!.profilePicture,
                                          ),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.person,
                                                color: Color(0xFF8b2cf5),
                                                size: 50,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.person,
                                            color: Color(0xFF8b2cf5),
                                            size: 50,
                                          ),
                                        ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Artist Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _artist!.name,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF282828),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${_songs.length} Songs • ${_albums.length} Albums',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Artist Bio
                            if (_artist!.bio.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'About',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF282828),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _artist!.bio,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Albums Section
                            if (_albums.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Albums',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF282828),
                                          ),
                                        ),
                                        if (_albums.length > 3)
                                          TextButton(
                                            onPressed: () {
                                              // Navigate to all albums
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(0xFF8b2cf5),
                                            ),
                                            child: const Text('See All'),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      height: 180,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _albums.length > 3 ? 3 : _albums.length,
                                        itemBuilder: (context, index) {
                                          final album = _albums[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/album',
                                                arguments: {'albumId': album.id},
                                              );
                                            },
                                            child: Container(
                                              width: 140,
                                              margin: const EdgeInsets.only(right: 16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                      _pbService.getAlbumCoverUrl(
                                                        album.collectionId,
                                                        album.id,
                                                        album.coverImage,
                                                      ),
                                                      width: 140,
                                                      height: 140,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Container(
                                                          width: 140,
                                                          height: 140,
                                                          color: Colors.grey[200],
                                                          child: const Icon(
                                                            Icons.album,
                                                            color: Color(0xFF8b2cf5),
                                                            size: 50,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    album.title,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Popular Songs Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Popular Songs',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF282828),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  _songs.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'No songs available',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: _songs.map((song) => 
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: FeaturedSongCard(song: song),
                                          )
                                        ).toList(),
                                      ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
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