import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const AudioTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(song.title),
      subtitle: Text(song.artist ?? 'Unknown Artist'),
      onTap: onTap,
    );
  }
}
