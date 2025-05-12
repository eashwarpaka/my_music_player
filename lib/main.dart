import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AudioPlayerApp());
}

class AudioPlayerApp extends StatelessWidget {
  const AudioPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AudioLibraryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AudioLibraryPage extends StatefulWidget {
  const AudioLibraryPage({super.key});

  @override
  State<AudioLibraryPage> createState() => _AudioLibraryPageState();
}

class _AudioLibraryPageState extends State<AudioLibraryPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    var status = await Permission.audio.request();
    if (status.isGranted) {
      loadSongs();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permission denied")));
    }
  }

  Future<void> loadSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs();
    setState(() {
      _songs = songs;
    });
  }

  Future<void> _playAudio(String filePath) async {
    await _player.setFilePath(filePath);
    _player.play();
  }

  void _stopAudio() {
    _player.stop();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My 音楽'),
        backgroundColor: const Color.fromARGB(255, 227, 226, 215),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 251),

      body:
          _songs.isEmpty
              ? const Center(child: Text('No songs found in storage.'))
              : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(song.title),
                    subtitle: Text(song.artist ?? 'Unknown Artist'),
                    onTap: () => _playAudio(song.data),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _stopAudio,
        backgroundColor: const Color.fromARGB(255, 37, 36, 36),
        child: const Icon(Icons.stop),
      ),
    );
  }
}
