import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class Song {
  final String id;
  final String collectionId;
  final String title;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final String songFile;
  final String songImage;
  final DateTime releaseDate;
  final int playCount;
  final String? lyrics;
  final DateTime? created;
  final DateTime? updated;

  Song({
    required this.id,
    required this.collectionId,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.albumId,
    required this.albumName,
    required this.songFile,
    required this.songImage,
    required this.releaseDate,
    required this.playCount,
    this.lyrics,
    this.created,
    this.updated,
  });

  // Factory constructor to create a Song from a PocketBase RecordModel
  factory Song.fromRecord(RecordModel record) {
    try {
      // Handle expanded relations
      final artistRecord = record.expand['artist_id'] as RecordModel?;
      final albumRecord = record.expand['album_id'] as RecordModel?;

      // Get release date with fallback
      DateTime releaseDate;
      try {
        releaseDate = DateTime.parse(record.getStringValue('release_date'));
      } catch (e) {
        // If release_date is missing or invalid, use created date or current date
        try {
          releaseDate = DateTime.parse(record.getStringValue('created'));
        } catch (e) {
          releaseDate = DateTime.now();
        }
      }

      // Get created and updated dates if available
      DateTime? created;
      DateTime? updated;
      try {
        created = DateTime.parse(record.getStringValue('created'));
      } catch (e) {
        created = null;
      }
      try {
        updated = DateTime.parse(record.getStringValue('updated'));
      } catch (e) {
        updated = null;
      }

      return Song(
        id: record.id,
        collectionId: record.collectionId,
        title: record.getStringValue('title'),
        artistId: record.getStringValue('artist_id'),
        artistName: artistRecord?.getStringValue('name') ?? 'Unknown Artist',
        albumId: record.getStringValue('album_id') ?? '',
        albumName: albumRecord?.getStringValue('title') ?? 'Unknown Album',
        songFile: record.getStringValue('song_file'),
        songImage: record.getStringValue('song_image'),
        releaseDate: releaseDate,
        playCount: record.getIntValue('play_count'),
        lyrics: record.data['lyrics'] as String?,
        created: created,
        updated: updated,
      );
    } catch (e) {
      debugPrint('Error creating Song from record: $e');
      // Return a placeholder song with minimal information
      return Song(
        id: record.id,
        collectionId: record.collectionId,
        title: record.data['title'] as String? ?? 'Unknown Title',
        artistId: record.data['artist_id'] as String? ?? '',
        artistName: 'Unknown Artist',
        albumId: record.data['album_id'] as String? ?? '',
        albumName: 'Unknown Album',
        songFile: record.data['song_file'] as String? ?? '',
        songImage: record.data['song_image'] as String? ?? '',
        releaseDate: DateTime.now(),
        playCount: 0,
      );
    }
  }

  // Add a copyWith method to support favorites functionality
  Song copyWith({
    String? id,
    String? collectionId,
    String? title,
    String? artistId,
    String? artistName,
    String? albumId,
    String? albumName,
    String? songFile,
    String? songImage,
    DateTime? releaseDate,
    int? playCount,
    String? lyrics,
    DateTime? created,
    DateTime? updated,
  }) {
    return Song(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? this.albumName,
      songFile: songFile ?? this.songFile,
      songImage: songImage ?? this.songImage,
      releaseDate: releaseDate ?? this.releaseDate,
      playCount: playCount ?? this.playCount,
      lyrics: lyrics ?? this.lyrics,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  // Add a toString method for debugging
  @override
  String toString() {
    return 'Song{id: $id, title: $title, artist: $artistName, album: $albumName}';
  }

  // Add equality operators
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  
}
