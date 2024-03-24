import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isBookmarked INTEGER,
        attachments TEXT
      )
    ''');
  }

  Future<String> _getExternalStoragePath() async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  Future<String> _saveAttachments(List<Object> attachments) async {
    final externalStoragePath = await _getExternalStoragePath();
    final attachmentPaths = <String>[];

    for (final attachment in attachments) {
      if (attachment is XFile) {
        final fileExtension = extension(attachment.path);
        final supportedExtensions = ['.jpg', '.png', '.webp', '.pdf', '.doc', '.docx', '.ppt', '.pptx', '.zip'];

        if (supportedExtensions.contains(fileExtension.toLowerCase())) {
          final newFilePath = join(externalStoragePath, '${attachment.name}$fileExtension');
          await attachment.saveTo(newFilePath);
          attachmentPaths.add(newFilePath);
        }
      }
    }

    return attachmentPaths.join(',');
  }

  Future<List<String>> _getAttachmentPaths(String attachmentsString) async {
    final attachmentPaths = attachmentsString.split(',');
    return attachmentPaths;
  }

  Future<void> insertNote(Note note) async {
    final db = await instance.database;
    final attachmentsString = await _saveAttachments(note.attachments);
    await db.insert('notes', {
      'title': note.title,
      'description': note.description,
      'isBookmarked': note.isBookmarked ? 1 : 0,
      'attachments': attachmentsString,
    });
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final maps = await db.query('notes');

    final notes = <Note>[];
    for (final map in maps) {
      final attachmentPaths = await _getAttachmentPaths(map['attachments'] as String);
      notes.add(
        Note(
          id: map['id'] as int?,
          title: map['title'] as String,
          description: map['description'] as String,
          isBookmarked: map['isBookmarked'] == 1,
          attachments: attachmentPaths.cast<Object>(),
        ),
      );
    }
    return notes;
  }

  Future<void> updateNote(Note note) async {
    final db = await instance.database;
    final attachmentsString = await _saveAttachments(note.attachments);
    await db.update(
      'notes',
      {
        'title': note.title,
        'description': note.description,
        'isBookmarked': note.isBookmarked ? 1 : 0,
        'attachments': attachmentsString,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await instance.database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Note {
  final int? id;
  final String title;
  final String description;
  final bool isBookmarked;
  final List<Object> attachments;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.isBookmarked,
    required this.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }
}