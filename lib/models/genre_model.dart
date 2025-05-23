import 'package:pocketbase/pocketbase.dart';

class Genre {
  final String id;
  final String collectionId;
  final String name;
  final String description;
  final DateTime created;
  final DateTime updated;
  int songCount; // Added for UI compatibility

  Genre({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.description,
    required this.created,
    required this.updated,
    this.songCount = 0,
  });

  factory Genre.fromRecord(RecordModel record) {
    return Genre(
      id: record.id,
      collectionId: record.collectionId,
      name: record.getStringValue('name'),
      description: record.getStringValue('description'),
      created: DateTime.parse(record.getStringValue('created')),
      updated: DateTime.parse(record.getStringValue('updated')),
    );
  }
}