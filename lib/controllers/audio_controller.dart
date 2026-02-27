import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  SongModel? _currentSong;
  Uint8List? _currentArtwork;
  bool _isPlaying = false;

  SongModel? get currentSong => _currentSong;
  Uint8List? get currentArtwork => _currentArtwork;
  bool get isPlaying => _isPlaying;

  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;
  Stream<PlayerState> get playerStateStream => player.playerStateStream;

  AudioController() {
    player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  Future<void> playSong(SongModel song, Uint8List? artwork) async {
    _currentSong = song;
    _currentArtwork = artwork;

    await player.setFilePath(song.data);
    await player.play();

    notifyListeners();
  }

  void pause() {
    player.pause();
  }

  void resume() {
    player.play();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  void stop() {
    player.stop();
    _currentSong = null;
    _currentArtwork = null;
    notifyListeners();
  }

  void dispose() {
    player.dispose();
  }
}
