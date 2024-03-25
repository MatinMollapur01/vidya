import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditScreen extends StatefulWidget {
  final Note? note;

  EditScreen({this.note});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
    _isBookmarked = widget.note?.isBookmarked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            CheckboxListTile(
              title: Text('Bookmark'),
              value: _isBookmarked,
              onChanged: (value) {
                setState(() {
                  _isBookmarked = value!;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper.instance;
                final note = Note(
                  id: widget.note?.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isBookmarked: _isBookmarked,
                );

                if (widget.note == null) {
                  await dbHelper.insertNote(note);
                } else {
                  await dbHelper.updateNote(note);
                }

                Navigator.pop(context);
              },
              child: Text(widget.note == null ? 'Add Note' : 'Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
