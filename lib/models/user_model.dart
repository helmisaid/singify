class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final bool verified;
  final DateTime created;
  final DateTime updated;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.verified,
    required this.created,
    required this.updated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? '',
      avatar: json['avatar'],
      verified: json['verified'] ?? false,
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'verified': verified,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}
