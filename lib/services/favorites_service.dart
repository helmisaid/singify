import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singify/models/song_model.dart';
import 'dart:convert';

class FavoritesService extends ChangeNotifier {
  List<Song> _favoriteSongs = [];
  
  List<Song> get favoriteSongs => _favoriteSongs;
  
  FavoritesService() {
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_songs') ?? [];
      
      // Note: You'll need to load the actual song data from your PocketBaseService
      // This is just loading the IDs for now
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }
  
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = _favoriteSongs.map((song) => song.id).toList();
      await prefs.setStringList('favorite_songs', favoriteIds);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
  
  bool isFavorite(String songId) {
    return _favoriteSongs.any((song) => song.id == songId);
  }
  
  void toggleFavorite(Song song) {
    if (isFavorite(song.id)) {
      _favoriteSongs.removeWhere((s) => s.id == song.id);
    } else {
      _favoriteSongs.add(song);
    }
    _saveFavorites();
    notifyListeners();
  }
  
  void addToFavorites(Song song) {
    if (!isFavorite(song.id)) {
      _favoriteSongs.add(song);
      _saveFavorites();
      notifyListeners();
    }
  }
  
  void removeFromFavorites(String songId) {
    _favoriteSongs.removeWhere((song) => song.id == songId);
    _saveFavorites();
    notifyListeners();
  }
  
  void clearFavorites() {
    _favoriteSongs.clear();
    _saveFavorites();
    notifyListeners();
  }
}