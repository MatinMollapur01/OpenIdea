import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'main.dart';

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);
    return await openDatabase(
      path, 
      version: 5, // Increase the version to 5
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        category TEXT,
        isArchived INTEGER DEFAULT 0,
        isPinned INTEGER DEFAULT 0,
        tags TEXT DEFAULT '[]',
        isLocked INTEGER DEFAULT 0
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN isArchived INTEGER DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE notes ADD COLUMN isPinned INTEGER DEFAULT 0');
    }
    if (oldVersion < 4) {
      // Check if the 'tags' column exists before adding it
      var columns = await db.rawQuery('PRAGMA table_info(notes)');
      bool tagsColumnExists = columns.any((column) => column['name'] == 'tags');
      if (!tagsColumnExists) {
        await db.execute('ALTER TABLE notes ADD COLUMN tags TEXT DEFAULT \'[]\'');
      }
    }
    if (oldVersion < 5) {
      // Check if the 'isLocked' column exists before adding it
      var columns = await db.rawQuery('PRAGMA table_info(notes)');
      bool isLockedColumnExists = columns.any((column) => column['name'] == 'isLocked');
      if (!isLockedColumnExists) {
        await db.execute('ALTER TABLE notes ADD COLUMN isLocked INTEGER DEFAULT 0');
      }
    }
  }

  Future<int> insertNote(Note note) async {
    Database db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;
    var notes = await db.query('notes', orderBy: 'id DESC');
    return notes.map((c) => Note.fromMap(c)).toList();
  }

  Future<int> updateNote(Note note) async {
    Database db = await instance.database;
    return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> updateNoteArchiveStatus(int id, bool isArchived) async {
    Database db = await instance.database;
    return await db.update(
      'notes',
      {'isArchived': isArchived ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateNotePinStatus(int id, bool isPinned) async {
    Database db = await instance.database;
    return await db.update(
      'notes',
      {'isPinned': isPinned ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateNoteLockStatus(int id, bool isLocked) async {
    Database db = await instance.database;
    return await db.update(
      'notes',
      {'isLocked': isLocked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}

insertNote(Note note) {}