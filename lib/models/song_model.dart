class Song {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final bool isFavorite;
  final String? lyrics;
  final String genre;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    this.isFavorite = false,
    this.lyrics,
    this.genre = 'Pop', // Default genre
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? albumArt,
    bool? isFavorite,
    String? lyrics,
    String? genre,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumArt: albumArt ?? this.albumArt,
      isFavorite: isFavorite ?? this.isFavorite,
      lyrics: lyrics ?? this.lyrics,
      genre: genre ?? this.genre,
    );
  }
}
