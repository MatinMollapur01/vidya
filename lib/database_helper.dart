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
        content TEXT,
        isBookmarked INTEGER
      )
    ''');
  }

  Future<void> insertNote(Note note) async {
    final db = await instance.database;
    await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int?,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        content: maps[i]['content'] as String,
        isBookmarked: maps[i]['isBookmarked'] == 1,
      );
    });
  }

  Future<void> updateNote(Note note) async {
    final db = await instance.database;
    await db.update(
      'notes',
      note.toMap(),
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
  final String content;
  final bool isBookmarked;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.isBookmarked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }
}