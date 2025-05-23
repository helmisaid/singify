import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:singify/models/song_model.dart';

class PlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String _errorMessage = '';

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get duration => _duration;
  Duration get position => _position;
  String get errorMessage => _errorMessage;

  PlayerService() {
    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      _isPlaying = playerState.playing;

      // Check for errors
      if (playerState.processingState == ProcessingState.completed) {
        // Song completed playing
        _isPlaying = false;
      }

      notifyListeners();
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((newDuration) {
      if (newDuration != null) {
        _duration = newDuration;
        notifyListeners();
      }
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });

    // Listen to buffering state
    _audioPlayer.processingStateStream.listen((state) {
      _isLoading = state == ProcessingState.loading ||
          state == ProcessingState.buffering;
      notifyListeners();
    });

    // Listen to errors
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace st) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      debugPrint('Player error: $e');
    });
  }

  // Play a song
  Future<void> playSong(Song song) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Check if the song URL is valid
      final songUrl = song.songFile;
      if (songUrl.isEmpty) {
        _errorMessage = 'Song URL is empty';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Log the song URL for debugging
      debugPrint('Playing song from URL: $songUrl');

      // Stop any currently playing song
      await _audioPlayer.stop();

      // Set the audio source
      await _audioPlayer.setUrl(songUrl);
      _currentSong = song;

      // Start playing
      await _audioPlayer.play();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error playing song: ${e.toString()}';
      debugPrint('Error playing song: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pause the current song
  Future<void> pauseSong() async {
    await _audioPlayer.pause();
  }

  // Resume playing
  Future<void> resumeSong() async {
    await _audioPlayer.play();
  }

  // Seek to a specific position
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Stop playing
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Dispose resources
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
