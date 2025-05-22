import 'package:pocketbase/pocketbase.dart';

class Artist {
  final String id;
  final String collectionId;
  final String name;
  final String bio;
  final String profilePicture;
  final DateTime created;
  final DateTime updated;

  Artist({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.bio,
    required this.profilePicture,
    required this.created,
    required this.updated,
  });

  factory Artist.fromRecord(RecordModel record) {
    return Artist(
      id: record.id,
      collectionId: record.collectionId,
      name: record.getStringValue('name'),
      bio: record.getStringValue('bio'),
      profilePicture: record.getStringValue('profile_picture'),
      created: DateTime.parse(record.getStringValue('created')),
      updated: DateTime.parse(record.getStringValue('updated')),
    );
  }
}