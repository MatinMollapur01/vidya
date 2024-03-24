import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerScreen extends StatefulWidget {
  final Function(List<Object>) onFilesSelected;

  const FilePickerScreen({Key? key, required this.onFilesSelected})
      : super(key: key);

  @override
  _FilePickerScreenState createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      final files = result.paths.map((path) => File(path!)).toList();
      widget.onFilesSelected(files);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Files'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickFiles,
          child: Text('Pick Files'),
        ),
      ),
    );
  }
}