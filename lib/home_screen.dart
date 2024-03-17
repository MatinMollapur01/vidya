import 'package:flutter/material.dart';
import 'package:vidya/note.dart' as model;
import 'package:vidya/note_category.dart';
import 'edit_screen.dart';
import 'toggle_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<model.Note> notes = [
    model.Note(
      title: 'Note 1',
      categoryId: 1,
      categoryColor: Colors.blue,
      category: NoteCategory(id: 1, name: 'Personal', color: Colors.blue),
    ),
    model.Note(
      title: 'Note 2',
      categoryId: 2,
      categoryColor: Colors.green,
      category: NoteCategory(id: 2, name: 'Work', color: Colors.green),
    ),
    model.Note(
      title: 'Note 3',
      categoryId: 3,
      categoryColor: Colors.orange,
      category: NoteCategory(id: 3, name: 'Study', color: Colors.orange),
    ),
    // Add more notes as needed
  ];

  List<NoteCategory> categories = [
    NoteCategory(id: 1, name: 'Personal', color: Colors.blue),
    NoteCategory(id: 2, name: 'Work', color: Colors.green),
    NoteCategory(id: 3, name: 'Study', color: Colors.orange),
    // Add more categories as needed
  ];

  NoteCategory? _selectedCategory;

  get bookmarkedNotes => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vidya Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Open toggle menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ToggleMenu(bookmarkedNotes: bookmarkedNotes)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show category filter dialog
              _showCategoryFilterDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          // Filter notes by selected category
          if (_selectedCategory != null && _selectedCategory!.id != 0) {
            if (note.categoryId != _selectedCategory!.id) {
              return SizedBox.shrink();
            }
          }

          return ListTile(
            title: Text(note.title),
            // Display category color next to note title
            leading: Container(
              width: 10,
              color: note.categoryColor,
            ),
            onTap: () async {
              // Navigate to edit screen to edit note
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditScreen(note: note)),
              );
              if (updatedNote != null && updatedNote is model.Note) {
                setState(() {
                  notes[index] = updatedNote;
                });
              }
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
        onPressed: () async {
          // Navigate to edit screen to create new note
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditScreen(note: model.Note(title: ''))),
          );
          if (newNote != null && newNote is model.Note) {
            setState(() {
              notes.add(newNote);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to show category filter dialog
  void _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Category'),
          content: DropdownButtonFormField<NoteCategory>(
            value: _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
              Navigator.pop(context);
            },
            items: [
              NoteCategory(id: 0, name: 'All Categories', color: Colors.grey), // Option to show all categories
              ...categories,
            ].map<DropdownMenuItem<NoteCategory>>((category) {
              return DropdownMenuItem<NoteCategory>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
