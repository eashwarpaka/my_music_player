import '../../config/app_imports.dart';
import '../../services/audio_service.dart';

class AudioTile extends StatelessWidget {
  final SongModel song;
  final AudioService service;

  const AudioTile({super.key, required this.song, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(song.title),
      subtitle: Text(song.artist ?? 'Unknown Artist'),
      onTap: () => service.playAudio(song.data),
    );
  }
}
