import 'package:flutter/material.dart';
import 'package:vidya/note.dart' as model;
import 'package:vidya/note_category.dart';
import 'package:vidya/constants.dart';

// Define the categories list
List<NoteCategory> categories = [
  NoteCategory(id: 1, name: 'Category 1', color: Colors.red),
  NoteCategory(id: 2, name: 'Category 2', color: Colors.blue),
  // Add more categories as needed
];

class EditScreen extends StatefulWidget {
  final model.Note note;

  EditScreen({required this.note});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _controller;
  late NoteCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.title);
    _selectedCategory = widget.note.category ?? uncategorizedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title.isEmpty ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(labelText: 'Enter your note'),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<NoteCategory>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: [
                DropdownMenuItem<NoteCategory>(
                  value: uncategorizedCategory,
                  child: Text(uncategorizedCategory.name),
                ),
                ...categories.map<DropdownMenuItem<NoteCategory>>((category) {
                  return DropdownMenuItem<NoteCategory>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Create a new Note with updated title and category
                final updatedNote = model.Note(
                  title: _controller.text,
                  category: _selectedCategory,
                );
                Navigator.pop(context, updatedNote);
              },
              child: Text(widget.note.title.isEmpty ? 'Add Note' : 'Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}