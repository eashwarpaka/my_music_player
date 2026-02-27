import 'config/app_imports.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'ui/screens/root_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const AudioPlayerApp(),
    ),
  );
}

class AudioPlayerApp extends StatelessWidget {
  const AudioPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.currentTheme,
      home: const RootScreen(), // ✅ IMPORTANT
    );
  }
}
