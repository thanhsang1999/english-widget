import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'vocabulary.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vocabulary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL
      )
    ''');
  }

  Future<int> addWord(Vocabulary vocab) async {
    final db = await instance.database;
    return await db.insert('vocabulary', vocab.toMap());
  }

  Future<List<Vocabulary>> getAllWords() async {
    final db = await instance.database;
    final result = await db.query('vocabulary');

    return result.map((map) => Vocabulary.fromMap(map)).toList();
  }

  Future<void> deleteWord(int id) async {
    final db = await instance.database;
    await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }
}
