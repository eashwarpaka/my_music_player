import 'dart:typed_data';

import 'package:my_music/config/app_imports.dart';
import 'package:my_music/widgets/music_player_controls.dart';

class AudioLibraryPage extends StatefulWidget {
  const AudioLibraryPage({super.key});

  @override
  State<AudioLibraryPage> createState() => _AudioLibraryPageState();
}

class _AudioLibraryPageState extends State<AudioLibraryPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];

  int _currentIndex = -1;
  bool _isPlaying = false;
  bool _isSearching = false;

  Uint8List? _artwork;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission();

    _player.positionStream.listen((pos) {
      if (mounted) {
        setState(() {
          _position = pos;
        });
      }
      if (_position >= _duration) {
        _playNext();
      }
    });

    _player.durationStream.listen((dur) {
      if (mounted) {
        setState(() {
          _duration = dur ?? Duration.zero;
        });
      }
    });
  }

  Future<void> requestPermission() async {
    var status = await Permission.audio.request();
    if (status.isGranted) {
      loadSongs();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Permission denied")));
      }
    }
  }

  Future<void> loadSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs();
    if (mounted) {
      setState(() {
        _songs = songs;
        _filteredSongs = songs;
      });
    }
  }

  Future<void> _playAudio(int index) async {
    await _player.setFilePath(_songs[index].data);
    _player.play();
    final art = await _audioQuery.queryArtwork(
      _songs[index].id,
      ArtworkType.AUDIO,
    );
    if (mounted) {
      setState(() {
        _currentIndex = index;
        _isPlaying = true;
        _artwork = art;
      });
    }
  }

  void _pauseAudio() {
    _player.pause();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _resumeAudio() {
    _player.play();
    if (mounted) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _seekAudio(double value) {
    _player.seek(Duration(seconds: value.toInt()));
  }

  void _stopAudio() {
    _player.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentIndex = -1;
        _artwork = null;
      });
    }
  }

  void _playNext() {
    if (_songs.isEmpty) return;
    int nextIndex = (_currentIndex + 1) % _songs.length;
    _playAudio(nextIndex);
  }

  void _playPrevious() {
    if (_songs.isEmpty) return;
    int prevIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    _playAudio(prevIndex);
  }

  void _confirmAndDeleteSong(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Remove Song',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to remove this song from the list?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    final songToRemove = _filteredSongs[index];
                    _songs.remove(songToRemove);
                    _filteredSongs.removeAt(index);
                    if (_currentIndex == index) {
                      _stopAudio();
                    }
                  });
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Song removed from the list"),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  cursorColor: Colors.grey,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    hintText: 'Search songs...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredSongs =
                          _songs
                              .where(
                                (song) => song.title.toLowerCase().contains(
                                  value.toLowerCase(),
                                ),
                              )
                              .toList();
                    });
                  },
                )
                : Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/chopper.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'My 音楽',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _filteredSongs = _songs;
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<String>(
            color: Colors.black87,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'delete') {
                _confirmAndDeleteSong(_currentIndex);
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(
                      'Delete Current Song',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body:
          _songs.isEmpty
              ? const Center(
                child: Text(
                  'No songs found in storage.',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.only(top: 100),
                itemCount: _filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = _filteredSongs[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.white),
                    title: Text(
                      song.title,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      song.artist ?? 'Unknown Artist',
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    tileColor:
                        _currentIndex == index
                            ? const Color.fromARGB(
                              255,
                              255,
                              2,
                              2,
                            ).withOpacity(0.2)
                            : Colors.transparent,
                    onTap: () {
                      if (_currentIndex == index && _isPlaying) {
                        _pauseAudio();
                      } else if (_currentIndex == index && !_isPlaying) {
                        _resumeAudio();
                      } else {
                        _playAudio(index);
                      }
                    },
                  );
                },
              ),
      bottomNavigationBar:
          _currentIndex == -1
              ? const SizedBox()
              : MusicPlayerControls(
                title: _songs[_currentIndex].title,
                isPlaying: _isPlaying,
                position: _position,
                duration: _duration,
                onSeek: _seekAudio,
                onPlay: _resumeAudio,
                onPause: _pauseAudio,
                onNext: _playNext,
                onPrevious: _playPrevious,
                onStop: _stopAudio,
                artwork: _artwork,
              ),
    );
  }
}
