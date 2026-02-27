import 'package:flutter/material.dart';
import '../../controllers/audio_controller.dart';

class GenericScreen extends StatefulWidget {
  final AudioController audioController;

  const GenericScreen({super.key, required this.audioController});

  @override
  State<GenericScreen> createState() => _GenericScreenState();
}

class _GenericScreenState extends State<GenericScreen> {
  final List<String> _genres = [
    "Pop",
    "Rock",
    "Jazz",
    "Hip-Hop",
    "Classical",
    "Electronic",
  ];

  final TextEditingController _controller = TextEditingController();

  void _addGenre() {
    _controller.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add Genre"),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter genre name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;

                  setState(() {
                    _genres.add(_controller.text.trim());
                  });

                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _renameGenre(int index) {
    _controller.text = _genres[index];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Rename Genre"),
            content: TextField(controller: _controller),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;

                  setState(() {
                    _genres[index] = _controller.text.trim();
                  });

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _deleteGenre(int index) {
    setState(() {
      _genres.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Genres"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGenre,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: _genres.length,
          itemBuilder: (context, index) {
            final genre = _genres[index];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Later: Filter songs by genre
                },
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text("Rename"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _renameGenre(index);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text("Delete"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _deleteGenre(index);
                                },
                              ),
                            ],
                          ),
                        ),
                  );
                },
                child: Center(
                  child: Text(
                    genre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
