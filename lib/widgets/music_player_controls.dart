import 'dart:typed_data';

import 'package:my_music/config/app_imports.dart';

class MusicPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final String title;
  final Duration position;
  final Duration duration;
  final ValueChanged<double> onSeek;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onNext;
  final VoidCallback onStop;
  final VoidCallback onPrevious;
  final Uint8List? artwork;

  const MusicPlayerControls({
    super.key,
    required this.isPlaying,
    required this.title,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onStop,
    required this.onPrevious,
    this.artwork,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF414345)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Controls Row
          Row(
            children: [
              // Artwork
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    artwork != null
                        ? Image.memory(
                          artwork!,
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          width: 42,
                          height: 42,
                          color: Colors.grey[600],
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                        ),
              ),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Previous
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: onPrevious,
                splashRadius: 22,
              ),

              // Animated Play/Pause
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                child: IconButton(
                  key: ValueKey(isPlaying),
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: isPlaying ? onPause : onPlay,
                  splashRadius: 28,
                ),
              ),

              // Next
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: onNext,
                splashRadius: 22,
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Compact Slider Row
          Row(
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.grey[600],
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                  ),
                  child: Slider(
                    value: position.inSeconds.toDouble(),
                    max:
                        duration.inSeconds > 0
                            ? duration.inSeconds.toDouble()
                            : 1,
                    onChanged: onSeek,
                  ),
                ),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
