import 'package:flutter/material.dart';
import 'edit_screen.dart';
import 'toggle_menu.dart';
import 'database_helper.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleDarkMode;

  const HomeScreen({Key? key, required this.toggleDarkMode}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final dbHelper = DatabaseHelper.instance;
    final allNotes = await dbHelper.getNotes();
    setState(() {
      _notes = allNotes;
      _filteredNotes = allNotes;
    });
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = _notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vidya'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToggleMenu(
                    toggleDarkMode: widget.toggleDarkMode,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterNotes,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];

                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.description),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      PopupMenuItem(
                        value: 'bookmark',
                        child: Text(note.isBookmarked ? 'Unbookmark' : 'Bookmark'),
                      ),
                    ],
                    onSelected: (value) async {
                      final dbHelper = DatabaseHelper.instance;
                      if (value == 'delete') {
                        await dbHelper.deleteNote(note.id!);
                        setState(() {
                          _notes.remove(note);
                          _filteredNotes.remove(note);
                        });
                      } else if (value == 'bookmark') {
                        final updatedNote = Note(
                          id: note.id,
                          title: note.title,
                          description: note.description,
                          isBookmarked: !note.isBookmarked,
                          attachments: note.attachments,
                        );
                        await dbHelper.updateNote(updatedNote);
                        setState(() {
                          _notes[_notes.indexWhere((n) => n.id == note.id)] =
                              updatedNote;
                          _filteredNotes[index] = updatedNote;
                        });
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditScreen(note: note)),
                    ).then((_) {
                      _loadNotes();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditScreen()),
          ).then((_) {
            _loadNotes();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}