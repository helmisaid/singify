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
  });

  // Factory constructor to create a Song from a PocketBase RecordModel
  factory Song.fromRecord(RecordModel record) {
    // Handle expanded relations
    final artistRecord = record.expand['artist_id'] as RecordModel?;
    final albumRecord = record.expand['album_id'] as RecordModel?;

    return Song(
      id: record.id,
      collectionId: record.collectionId,
      title: record.getStringValue('title'),
      artistId: record.getStringValue('artist_id'),
      artistName: artistRecord?.getStringValue('name') ?? 'Unknown Artist',
      albumId: record.getStringValue('album_id'),
      albumName: albumRecord?.getStringValue('name') ?? 'Unknown Album',
      songFile: record.getStringValue('song_file'),
      songImage: record.getStringValue('song_image'),
      releaseDate: DateTime.parse(record.getStringValue('release_date')),
      playCount: record.getIntValue('play_count'),
    );
  }
}