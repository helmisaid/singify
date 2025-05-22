import 'package:pocketbase/pocketbase.dart';

class Album {
  final String id;
  final String collectionId;
  final String title;
  final String artistId;
  final String coverImage;
  final DateTime releaseDate;
  final DateTime created;
  final DateTime updated;
  final String? artistName; // For expanded relations

  Album({
    required this.id,
    required this.collectionId,
    required this.title,
    required this.artistId,
    required this.coverImage,
    required this.releaseDate,
    required this.created,
    required this.updated,
    this.artistName,
  });

  factory Album.fromRecord(RecordModel record) {
    // Handle expanded relations
    final artistRecord = record.expand['artist_id'] as RecordModel?;
    
    return Album(
      id: record.id,
      collectionId: record.collectionId,
      title: record.getStringValue('title'),
      artistId: record.getStringValue('artist_id'),
      coverImage: record.getStringValue('cover_image'),
      releaseDate: DateTime.parse(record.getStringValue('release_date')),
      created: DateTime.parse(record.getStringValue('created')),
      updated: DateTime.parse(record.getStringValue('updated')),
      artistName: artistRecord?.getStringValue('name'),
    );
  }
}