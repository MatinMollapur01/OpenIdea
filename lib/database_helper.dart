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
      version: 6, // Increase the version to 6
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

    await db.execute('''
      CREATE TABLE note_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        note_id INTEGER,
        title TEXT,
        content TEXT,
        timestamp INTEGER,
        FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
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
    if (oldVersion < 6) {
      // Add the note_history table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS note_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          note_id INTEGER,
          title TEXT,
          content TEXT,
          timestamp INTEGER,
          FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
        )
      ''');
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
    await insertNoteHistory(note.id!, note.title, note.content);
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

  Future<int> insertNoteHistory(int noteId, String title, String content) async {
    Database db = await instance.database;
    return await db.insert('note_history', {
      'note_id': noteId,
      'title': title,
      'content': content,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getNoteHistory(int noteId) async {
    Database db = await instance.database;
    return await db.query(
      'note_history',
      where: 'note_id = ?',
      whereArgs: [noteId],
      orderBy: 'timestamp DESC',
    );
  }
}

insertNote(Note note) {}