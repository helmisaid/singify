import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/models/song_model.dart';
import 'package:singify/models/artist_model.dart';
import 'package:singify/services/pocketbase_service.dart';
import 'package:singify/utils/constants.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:singify/widgets/popular_lyric_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PocketBaseService _pbService = PocketBaseService();

  List<Song> _searchResults = [];
  List<Song> _featuredSongs = [];
  List<Artist> _popularArtists = [];

  bool _isLoading = true;
  bool _isSearching = false;
  bool _showSearchResults = false;
  String _errorMessage = '';
  int _currentIndex = 1; // Explore tab selected

  // Recent searches
  final List<String> _recentSearches = [
    'Taylor Swift - Anti-Hero',
    'Coldplay - Sparks',
    'Coldplay - Viva La Vida',
  ];

  // Trending searches
  final List<String> _trendingSearches = [
    'Taylor Swift',
    'Ed Sheeran',
    'Billie Eilish',
    'The Weeknd',
    'Ariana Grande',
  ];

  // Track which item is being pressed for visual feedback
  int? _pressedRecentIndex;
  String? _pressedTrending;
  String? _pressedArtist;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Fetch featured songs
      final songRecords = await _pbService.getFeaturedSongs(limit: 10);
      final songs =
          songRecords.map((record) => Song.fromRecord(record)).toList();

      // Fetch popular artists
      final artists = await _pbService.getAllArtists();

      setState(() {
        _featuredSongs = songs;
        _popularArtists = artists.take(5).toList(); // Take top 5 artists
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data: $e';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    try {
      // Search for songs by title or artist
      final songRecords = await _pbService.pb.collection('songs').getList(
            page: 1,
            perPage: 20,
            filter: 'title ~ "$query" || expand.artist_id.name ~ "$query"',
            expand: 'artist_id,album_id',
          );

      final songs =
          songRecords.items.map((record) => Song.fromRecord(record)).toList();

      setState(() {
        _searchResults = songs;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _errorMessage = 'Search failed: $e';
      });
    }
  }

  void _addToRecentSearches(String query) {
    if (query.isEmpty) return;

    setState(() {
      // Remove if already exists
      _recentSearches
          .removeWhere((item) => item.toLowerCase() == query.toLowerCase());

      // Add to the beginning
      _recentSearches.insert(0, query);

      // Keep only the most recent 5 searches
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    });
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search history cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeRecentSearch(int index) {
    final removed = _recentSearches[index];
    setState(() {
      _recentSearches.removeAt(index);
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "$removed"'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF8b2cf5),
          onPressed: () {
            setState(() {
              _recentSearches.insert(index, removed);
            });
          },
        ),
      ),
    );
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
                    Text(
                      'Singify',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: const Color(0xFF8b2cf5),
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(width: 40), // Placeholder for balance
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color:
                        Color(0xFF282828), // Darker text for better readability
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search songs, artist, or lyrics...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600], // Darker hint text
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF666666)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: Color(0xFF666666)),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                              // Add haptic feedback
                              HapticFeedback.lightImpact();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onSubmitted: (value) {
                    _addToRecentSearches(value);
                    _performSearch(value);
                    // Add haptic feedback
                    HapticFeedback.mediumImpact();
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _searchResults = [];
                        _isSearching = false;
                        _showSearchResults = false;
                      });
                    } else if (value.length > 2) {
                      // Only search if at least 3 characters
                      _performSearch(value);
                    }
                  },
                ),
              ),
            ),

            // Main Content
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF8b2cf5)),
                      ),
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? Expanded(
                        child: Center(
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
                                onPressed: _fetchInitialData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8b2cf5),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: _showSearchResults
                            ? _buildSearchResults()
                            : _buildSearchHome(),
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
                        // Already on explore/search screen
                        HapticFeedback.selectionClick();
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

  Widget _buildSearchHome() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Searches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF282828), // Darker text
                  ),
                ),
                if (_recentSearches.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      _clearRecentSearches();
                      // Add haptic feedback
                      HapticFeedback.mediumImpact();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF8b2cf5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (_recentSearches.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'No recent searches',
                  style: TextStyle(color: Color(0xFF666666)), // Darker text
                ),
              )
            else
              Column(
                children: List.generate(_recentSearches.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: _pressedRecentIndex == index
                          ? Colors.grey[200]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          _searchController.text = _recentSearches[index];
                          _performSearch(_recentSearches[index]);
                          // Add haptic feedback
                          HapticFeedback.selectionClick();
                        },
                        onTapDown: (_) {
                          setState(() {
                            _pressedRecentIndex = index;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _pressedRecentIndex = null;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _pressedRecentIndex = null;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.history,
                                  color: Color(0xFF666666)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _recentSearches[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF282828), // Darker text
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Color(0xFF666666)),
                                onPressed: () {
                                  _removeRecentSearch(index);
                                  // Add haptic feedback
                                  HapticFeedback.lightImpact();
                                },
                                splashRadius:
                                    20, // Smaller splash for better UX
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

            const SizedBox(height: 30),

            // Trending Searches
            const Text(
              'Trending Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF282828), // Darker text
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _trendingSearches.map((search) {
                final isPressed = _pressedTrending == search;
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    _addToRecentSearches(search);
                    _performSearch(search);
                    // Add haptic feedback
                    HapticFeedback.selectionClick();
                  },
                  onTapDown: (_) {
                    setState(() {
                      _pressedTrending = search;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _pressedTrending = null;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _pressedTrending = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPressed
                          ? const Color(0xFF8b2cf5).withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: isPressed
                          ? Border.all(color: const Color(0xFF8b2cf5), width: 1)
                          : null,
                    ),
                    child: Text(
                      '#$search',
                      style: TextStyle(
                        fontSize: 16,
                        color: isPressed
                            ? const Color(0xFF8b2cf5)
                            : const Color(0xFF282828),
                        fontWeight:
                            isPressed ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Popular Artists
            const Text(
              'Popular Artists',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF282828), // Darker text
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _popularArtists.map((artist) {
                final isPressed = _pressedArtist == artist.name;
                return GestureDetector(
                  onTap: () {
                    _searchController.text = artist.name;
                    _addToRecentSearches(artist.name);
                    _performSearch(artist.name);
                    // Add haptic feedback
                    HapticFeedback.selectionClick();
                  },
                  onTapDown: (_) {
                    setState(() {
                      _pressedArtist = artist.name;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _pressedArtist = null;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _pressedArtist = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPressed
                          ? const Color(0xFF8b2cf5).withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: isPressed
                          ? Border.all(color: const Color(0xFF8b2cf5), width: 1)
                          : null,
                    ),
                    child: Text(
                      '#${artist.name}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isPressed
                            ? const Color(0xFF8b2cf5)
                            : const Color(0xFF282828),
                        fontWeight:
                            isPressed ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8b2cf5),
        ),
      );
    } else if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              'No results found for "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666), // Darker text
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showSearchResults = false;
                  _searchController.clear();
                });
                // Add haptic feedback
                HapticFeedback.mediumImpact();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8b2cf5),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Back to Search'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Results for "${_searchController.text}"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF282828), // Darker text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showSearchResults = false;
                    });
                    // Add haptic feedback
                    HapticFeedback.lightImpact();
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8b2cf5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: PopularLyricCard(
                      song: _searchResults[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/player',
                          arguments: _searchResults[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
