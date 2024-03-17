import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  final List<String> bookmarkedNotes;

  BookmarksPage({List<String>? bookmarkedNotes})
        : this.bookmarkedNotes = bookmarkedNotes ?? const [];

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
