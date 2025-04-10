import 'package:flutter/foundation.dart';
import 'package:singify/models/song_model.dart';

class FavoritesService extends ChangeNotifier {
  final List<Song> _favoriteSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;

  bool isFavorite(String songId) {
    return _favoriteSongs.any((song) => song.id == songId);
  }

  void toggleFavorite(Song song) {
    final isFav = isFavorite(song.id);
    
    if (isFav) {
      // Remove from favorites
      _favoriteSongs.removeWhere((s) => s.id == song.id);
    } else {
      // Add to favorites
      _favoriteSongs.add(song.copyWith(isFavorite: true));
    }
    
    notifyListeners();
  }
}
