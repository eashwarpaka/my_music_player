import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../controllers/audio_controller.dart';
import '/widgets/music_player_controls.dart';

class PlayerScreen extends StatefulWidget {
  final AudioController audioController;

  const PlayerScreen({super.key, required this.audioController});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late StreamSubscription<Duration> _positionSub;
  late StreamSubscription<Duration?> _durationSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _positionSub = widget.audioController.positionStream.listen((pos) {
      if (!mounted) return;
      setState(() => _position = pos);
    });

    _durationSub = widget.audioController.durationStream.listen((dur) {
      if (!mounted) return;
      setState(() => _duration = dur ?? Duration.zero);
    });
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _durationSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.audioController;
    final song = controller.currentSong;

    if (song == null) {
      return const Scaffold(body: Center(child: Text("No song playing")));
    }

    Uint8List? artwork = controller.currentArtwork;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          /// LARGE ARTWORK
          Expanded(
            child: Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child:
                    artwork != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.memory(artwork, fit: BoxFit.cover),
                        )
                        : const Icon(Icons.music_note, size: 100),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              song.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          const SizedBox(height: 20),

          /// CONTROLS
          MusicPlayerControls(
            isPlaying: controller.isPlaying,
            title: song.title,
            position: _position,
            duration: _duration,
            onSeek: (value) {
              controller.seek(Duration(seconds: value.toInt()));
            },
            onPlay: controller.resume,
            onPause: controller.pause,
            onNext: () {},
            onPrevious: () {},
            onStop: controller.stop,
            artwork: artwork,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
