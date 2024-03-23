import 'package:flutter/material.dart';
import 'database_helper.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<Note> _bookmarkedNotes = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedNotes();
  }

  Future<void> _loadBookmarkedNotes() async {
    final dbHelper = DatabaseHelper.instance;
    final allNotes = await dbHelper.getNotes();
    setState(() {
      _bookmarkedNotes = allNotes.where((note) => note.isBookmarked).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: _bookmarkedNotes.length,
        itemBuilder: (context, index) {
          final note = _bookmarkedNotes[index];

          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final dbHelper = DatabaseHelper.instance;
                await dbHelper.deleteNote(note.id!);
                setState(() {
                  _bookmarkedNotes.remove(note);
                });
              },
            ),
          );
        },
      ),
    );
  }
}