import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'file_picker_screen.dart';

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
  List<Object> _attachments = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController = TextEditingController(text: widget.note?.description ?? '');
    _isBookmarked = widget.note?.isBookmarked ?? false;
    _attachments = widget.note?.attachments ?? [];
  }

  void _showFilePickerScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilePickerScreen(
          onFilesSelected: (files) {
            setState(() {
              _attachments.addAll(files);
            });
          },
        ),
      ),
    );
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
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _showFilePickerScreen,
              child: Text('Add Attachments'),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _attachments.length,
                itemBuilder: (context, index) {
                  final attachment = _attachments[index];
                  if (attachment is XFile) {
                    final fileExtension = path.extension(attachment.path).toLowerCase();
                    if (fileExtension == '.jpg' ||
                        fileExtension == '.png' ||
                        fileExtension == '.webp') {
                      return Image.file(File(attachment.path));
                    } else if (fileExtension == '.pdf') {
                      return Container(
                        height: 100,
                        color: Colors.grey,
                        child: Center(
                          child: Text('PDF File'),
                        ),
                      );
                    } else if (fileExtension == '.doc' || fileExtension == '.docx') {
                      return Container(
                        height: 100,
                        color: Colors.blue,
                        child: Center(
                          child: Text('Word File'),
                        ),
                      );
                    } else if (fileExtension == '.ppt' || fileExtension == '.pptx') {
                      return Container(
                        height: 100,
                        color: Colors.red,
                        child: Center(
                          child: Text('PowerPoint File'),
                        ),
                      );
                    } else if (fileExtension == '.zip') {
                      return Container(
                        height: 100,
                        color: Colors.green,
                        child: Center(
                          child: Text('ZIP File'),
                        ),
                      );
                    }
                  }
                  return Text('Unsupported file type');
                },
              ),
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
                  attachments: _attachments,
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
