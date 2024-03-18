
import 'package:flutter/material.dart';
import 'edit_screen.dart';
import 'toggle_menu.dart';
import 'bookmarks_page.dart'; // Import bookmarks_page.dart

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> notes = ['Note 1', 'Note 2', 'Note 3']; // Dummy notes for now
  List<String> bookmarkedNotes = []; // List to store bookmarked notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vidya'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Open toggle menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ToggleMenu(bookmarkedNotes: bookmarkedNotes)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final isBookmarked = bookmarkedNotes.contains(note);

          return ListTile(
            title: Text(note),
            trailing: IconButton(
              icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () {
                setState(() {
                  if (isBookmarked) {
                    bookmarkedNotes.remove(note);
                  } else {
                    bookmarkedNotes.add(note);
                  }
                });
              },
            ),
            onTap: () {
              // Navigate to edit screen to edit note
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditScreen(note: note)),
              ).then((value) {
                if (value != null && value is String) {
                  setState(() {
                    notes[index] = value;
                  });
                }
              });
            },
            onLongPress: () {
              // Delete note
              setState(() {
                notes.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to edit screen to create new note
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditScreen(note: '')),
          ).then((value) {
            if (value != null && value is String) {
              setState(() {
                notes.add(value);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
