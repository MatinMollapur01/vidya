import 'package:flutter/material.dart';
import 'edit_screen.dart';
import 'toggle_menu.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

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
                MaterialPageRoute(builder: (context) => ToggleMenu()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];

          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.description),
            trailing: IconButton(
              icon: Icon(note.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () async {
                final dbHelper = DatabaseHelper.instance;
                final updatedNote = Note(
                  id: note.id,
                  title: note.title,
                  description: note.description,
                  content: note.content,
                  isBookmarked: !note.isBookmarked,
                );
                await dbHelper.updateNote(updatedNote);
                setState(() {
                  _notes[index] = updatedNote;
                });
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
            onLongPress: () async {
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.deleteNote(note.id!);
              setState(() {
                _notes.remove(note);
              });
            },
          );
        },
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