import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/library_controller.dart';
import '/widgets/audio_title.dart';

class HomeScreen extends StatefulWidget {
  final AudioController audioController;
  final LibraryController libraryController;

  const HomeScreen({
    super.key,
    required this.audioController,
    required this.libraryController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioController _audio;
  late LibraryController _library;

  late StreamSubscription<PlayerState> _stateSub;

  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];

  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();

    _audio = widget.audioController;
    _library = widget.libraryController;

    _init();

    _stateSub = _audio.playerStateStream.listen((state) {
      if (!mounted) return;

      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }

      setState(() {});
    });
  }

  Future<void> _init() async {
    bool permission = await _library.requestPermission();
    if (!permission) return;

    List<SongModel> songs = await _library.loadSongs();

    if (mounted) {
      setState(() {
        _songs = songs;
        _filteredSongs = songs;
      });
    }
  }

  Future<void> _play(int index) async {
    final song = _filteredSongs[index];

    final artwork = await _library.loadArtwork(song.id);

    await _audio.playSong(song, artwork);

    if (mounted) {
      setState(() {
        _currentIndex = _songs.indexOf(song);
      });
    }
  }

  void _playNext() {
    if (_songs.isEmpty || _currentIndex == -1) return;

    int next = (_currentIndex + 1) % _songs.length;

    int filteredIndex = _filteredSongs.indexOf(_songs[next]);

    if (filteredIndex != -1) {
      _play(filteredIndex);
    }
  }

  @override
  void dispose() {
    _stateSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _audio.currentSong;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My 音楽"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body:
          _songs.isEmpty
              ? const Center(child: Text("No songs found"))
              : ListView.builder(
                itemCount: _filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = _filteredSongs[index];

                  final isCurrent = currentSong?.id == song.id;

                  return AudioTile(
                    song: song,
                    onTap: () {
                      if (isCurrent && _audio.isPlaying) {
                        _audio.pause();
                      } else if (isCurrent && !_audio.isPlaying) {
                        _audio.resume();
                      } else {
                        _play(index);
                      }
                    },
                  );
                },
              ),
    );
  }
}
