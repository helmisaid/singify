import 'package:pocketbase/pocketbase.dart';
import 'package:singify/models/album_model.dart';
import 'package:singify/models/artist_model.dart';
import 'package:singify/models/genre_model.dart';
import 'package:singify/models/song_genre_model.dart';
// Import Flutter's foundation package for debugPrint
import 'package:flutter/foundation.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  final PocketBase pb;

  // Singleton pattern
  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal() 
      : pb = PocketBase('http://127.0.0.1:8090'); // Replace with your PocketBase URL

  // SONGS METHODS
  
  // Get featured songs (most played)
  Future<List<RecordModel>> getFeaturedSongs({int limit = 5}) async {
  try {
    final resultList = await pb.collection('songs').getList(
      page: 1,
      perPage: limit,
      sort: '-play_count', // Sort by play count descending
      expand: 'artist_id,album_id', // Expand artist and album relations
    );
    
    return resultList.items; // Return the items list, not the resultList itself
  } catch (e) {
    debugPrint('Error fetching featured songs: $e');
    return []; // Return an empty list on error
  }
}

  // Get song by ID
  Future<RecordModel?> getSongById(String id) async {
    try {
      final record = await pb.collection('songs').getOne(
        id,
        expand: 'artist_id,album_id',
      );
      return record;
    } catch (e) {
      print('Error fetching song: $e');
      return null;
    }
  }

  // Increment play count
  Future<void> incrementPlayCount(String songId) async {
    try {
      // First get the current song to get its play count
      final song = await pb.collection('songs').getOne(songId);
      final currentPlayCount = song.getIntValue('play_count');
      
      // Update the play count
      await pb.collection('songs').update(songId, body: {
        'play_count': currentPlayCount + 1,
      });
    } catch (e) {
      print('Error incrementing play count: $e');
    }
  }

  // GENRES METHODS
  
  // Get all genres
  Future<List<Genre>> getAllGenres() async {
    try {
      final resultList = await pb.collection('genres').getFullList(
        sort: 'name',
      );
      
      return resultList.map((record) => Genre.fromRecord(record)).toList();
    } catch (e) {
      print('Error fetching genres: $e');
      return [];
    }
  }

  // Get genre by ID
  Future<Genre?> getGenreById(String id) async {
    try {
      final record = await pb.collection('genres').getOne(id);
      return Genre.fromRecord(record);
    } catch (e) {
      print('Error fetching genre: $e');
      return null;
    }
  }

  // Get songs by genre
  Future<List<RecordModel>> getSongsByGenre(String genreId, {int limit = 20}) async {
    try {
      // First get the song_genres records for this genre
      final songGenresList = await pb.collection('song_genres').getList(
        page: 1,
        perPage: 100, // Get a large number to ensure we get all
        filter: 'genre_id = "$genreId"',
      );
      
      // Extract the song IDs
      final songIds = songGenresList.items.map((record) => 
        record.getStringValue('song_id')
      ).toList();
      
      if (songIds.isEmpty) {
        return [];
      }
      
      // Now get the actual songs
      // Create a filter like: id = "id1" || id = "id2" || ...
      final songIdsFilter = songIds.map((id) => 'id = "$id"').join(' || ');
      
      final songsList = await pb.collection('songs').getList(
        page: 1,
        perPage: limit,
        filter: songIdsFilter,
        expand: 'artist_id,album_id',
        sort: '-play_count',
      );
      
      return songsList.items;
    } catch (e) {
      print('Error fetching songs by genre: $e');
      return [];
    }
  }

  // ARTISTS METHODS
  
  // Get all artists
  Future<List<Artist>> getAllArtists() async {
    try {
      final resultList = await pb.collection('artists').getFullList(
        sort: 'name',
      );
      
      return resultList.map((record) => Artist.fromRecord(record)).toList();
    } catch (e) {
      print('Error fetching artists: $e');
      return [];
    }
  }

  // Get artist by ID
  Future<Artist?> getArtistById(String id) async {
    try {
      final record = await pb.collection('artists').getOne(id);
      return Artist.fromRecord(record);
    } catch (e) {
      print('Error fetching artist: $e');
      return null;
    }
  }

  // Get songs by artist
  Future<List<RecordModel>> getSongsByArtist(String artistId, {int limit = 20}) async {
    try {
      final songsList = await pb.collection('songs').getList(
        page: 1,
        perPage: limit,
        filter: 'artist_id = "$artistId"',
        expand: 'album_id',
        sort: '-play_count',
      );
      
      return songsList.items;
    } catch (e) {
      print('Error fetching songs by artist: $e');
      return [];
    }
  }

  // ALBUMS METHODS
  
  // Get all albums
  Future<List<Album>> getAllAlbums() async {
    try {
      final resultList = await pb.collection('album').getFullList(
        sort: '-release_date',
        expand: 'artist_id',
      );
      
      return resultList.map((record) => Album.fromRecord(record)).toList();
    } catch (e) {
      print('Error fetching albums: $e');
      return [];
    }
  }

  // Get album by ID
  Future<Album?> getAlbumById(String id) async {
    try {
      final record = await pb.collection('album').getOne(
        id,
        expand: 'artist_id',
      );
      return Album.fromRecord(record);
    } catch (e) {
      print('Error fetching album: $e');
      return null;
    }
  }

  // Get songs by album
  Future<List<RecordModel>> getSongsByAlbum(String albumId, {int limit = 50}) async {
    try {
      final songsList = await pb.collection('songs').getList(
        page: 1,
        perPage: limit,
        filter: 'album_id = "$albumId"',
        expand: 'artist_id',
        sort: 'created',
      );
      
      return songsList.items;
    } catch (e) {
      print('Error fetching songs by album: $e');
      return [];
    }
  }

  // Get albums by artist
  Future<List<Album>> getAlbumsByArtist(String artistId, {int limit = 20}) async {
    try {
      final albumsList = await pb.collection('album').getList(
        page: 1,
        perPage: limit,
        filter: 'artist_id = "$artistId"',
        sort: '-release_date',
      );
      
      return albumsList.items.map((record) => Album.fromRecord(record)).toList();
    } catch (e) {
      print('Error fetching albums by artist: $e');
      return [];
    }
  }

  // FILE URL HELPERS
  
  // Get song image URL
  String getSongImageUrl(String collectionId, String recordId, String fileName) {
    return '${pb.baseUrl}/api/files/$collectionId/$recordId/$fileName';
  }
  
  // Get song file URL
  String getSongFileUrl(String collectionId, String recordId, String fileName) {
    return '${pb.baseUrl}/api/files/$collectionId/$recordId/$fileName';
  }
  
  // Get artist profile picture URL
  String getArtistImageUrl(String collectionId, String recordId, String fileName) {
    return '${pb.baseUrl}/api/files/$collectionId/$recordId/$fileName';
  }
  
  // Get album cover URL
  String getAlbumCoverUrl(String collectionId, String recordId, String fileName) {
    return '${pb.baseUrl}/api/files/$collectionId/$recordId/$fileName';
  }

  // Add this method to your PocketBaseService class

// Count songs by genre
Future<int> countSongsByGenre(String genreId) async {
  try {
    final songGenresList = await pb.collection('song_genres').getList(
      page: 1,
      perPage: 1,
      filter: 'genre_id = "$genreId"',
    );
    
    // Access the totalItems property directly from the result
    return songGenresList.totalItems;
  } catch (e) {
    // Use proper logging instead of print
    debugPrint('Error counting songs by genre: $e');
    return 0;
  }
}

// Update genre with song count
Future<List<Genre>> getAllGenresWithSongCount() async {
  try {
    final resultList = await pb.collection('genres').getFullList(
      sort: 'name',
    );
    
    final genres = resultList.map((record) => Genre.fromRecord(record)).toList();
    
    // Get song counts for each genre
    for (var genre in genres) {
      final count = await countSongsByGenre(genre.id);
      genre.songCount = count;
    }
    
    return genres;
  } catch (e) {
    print('Error fetching genres with song count: $e');
    return [];
  }
}
}

