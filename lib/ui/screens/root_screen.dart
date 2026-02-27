import 'package:flutter/material.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/library_controller.dart';
import '/widgets/mini_player.dart';
import 'home_screen.dart';
import 'generic_screen.dart';
import 'player_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final PageController _pageController = PageController();

  final AudioController _audioController = AudioController();
  final LibraryController _libraryController = LibraryController();

  @override
  void dispose() {
    _pageController.dispose();
    _audioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            children: [
              HomeScreen(
                audioController: _audioController,
                libraryController: _libraryController,
              ),
              GenericScreen(audioController: _audioController),
              PlayerScreen(audioController: _audioController),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(
              audioController: _audioController,
              onTap: () {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
