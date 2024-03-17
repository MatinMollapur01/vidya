import 'package:flutter/material.dart';
import 'note_category.dart';

class Note {
  final String title;
  final int categoryId;
  final Color categoryColor;
  final NoteCategory? category;

  Note({
    required this.title,
    this.categoryId = 0, // Default value for categoryId
    this.categoryColor = Colors.grey, // Default value for categoryColor
    this.category = null, // Default value for category
  });
}