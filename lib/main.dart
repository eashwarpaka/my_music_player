import 'package:my_music/ui/audio_library_page.dart';

import 'config/app_imports.dart';

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
