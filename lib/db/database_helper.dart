import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry_model.dart';

class DatabaseHelper {
  // Create a singleton (ensures one shared database instance)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  // open or create the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gratify.db');
    return _database!;
  }

  // opens/creates the DB file
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // open database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE journal_entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      content TEXT NOT NULL,
      moods TEXT
    )
    ''');
  }

  //Insert new Note
  Future<int> insertNote(JournalEntry entry) async {
    final db = await instance.database;
    return await db.insert('journal_entries', entry.toMap());
  }

  //  Fetch all notes
  Future<List<JournalEntry>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('journal_entries', orderBy: 'date DESC');
    return result.map((map) => JournalEntry.fromMap(map)).toList();
  }

  // Update note
  Future<int> updateNote(JournalEntry entry) async {
    final db = await instance.database;
    if (entry.id == null) return 0;
    return await db.update(
      'journal_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Delete note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }

  // Close database
  Future close() async {
    final db = await _database;
    db?.close();
  }
}
