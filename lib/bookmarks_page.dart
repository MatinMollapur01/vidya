import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  final List<String> bookmarkedNotes;

  BookmarksPage({required this.bookmarkedNotes});

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: widget.bookmarkedNotes.length,
        itemBuilder: (context, index) {
          final note = widget.bookmarkedNotes[index];

          return ListTile(
            title: Text(note),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.bookmarkedNotes.remove(note);
                });
              },
            ),
          );
        },
      ),
    );
  }
}