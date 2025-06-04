import '../config/app_imports.dart';

class AudioService {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();

  Future<List<SongModel>> loadSongs() async {
    return await audioQuery.querySongs();
  }

  Future<void> playAudio(String filePath) async {
    await player.setFilePath(filePath);
    player.play();
  }

  void stopAudio() {
    player.stop();
  }

  void dispose() {
    player.dispose();
  }

  Future<bool> requestPermission() async {
    var status = await Permission.audio.request();
    return status.isGranted;
  }
}
