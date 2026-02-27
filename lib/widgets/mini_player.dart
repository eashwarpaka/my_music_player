import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controllers/audio_controller.dart';

class MiniPlayer extends StatefulWidget {
  final AudioController audioController;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.audioController,
    required this.onTap,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  late StreamSubscription _positionSub;
  late StreamSubscription _durationSub;

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

    if (song == null) return const SizedBox();

    double max = _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1;

    double value = _position.inSeconds.clamp(0, max.toInt()).toDouble();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.08),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    controller.currentArtwork != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            controller.currentArtwork!,
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                        )
                        : const Icon(Icons.music_note),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        song.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        controller.isPlaying
                            ? controller.pause()
                            : controller.resume();
                      },
                    ),
                  ],
                ),
                Slider(
                  value: value,
                  max: max,
                  onChanged: (v) {
                    controller.seek(Duration(seconds: v.toInt()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
