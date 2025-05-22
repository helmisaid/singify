import 'package:pocketbase/pocketbase.dart';

class SongGenre {
  final String id;
  final String collectionId;
  final String songId;
  final String genreId;
  final DateTime created;
  final DateTime updated;

  SongGenre({
    required this.id,
    required this.collectionId,
    required this.songId,
    required this.genreId,
    required this.created,
    required this.updated,
  });

  factory SongGenre.fromRecord(RecordModel record) {
    return SongGenre(
      id: record.id,
      collectionId: record.collectionId,
      songId: record.getStringValue('song_id'),
      genreId: record.getStringValue('genre_id'),
      created: DateTime.parse(record.getStringValue('created')),
      updated: DateTime.parse(record.getStringValue('updated')),
    );
  }
}