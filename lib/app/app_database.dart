import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  static Database _database;

  factory AppDatabase() => _instance;

  AppDatabase._();

  Future<Database> _init() async {
    return openDatabase(join(await getDatabasesPath(), "note_database.db"),
        version: 1, onCreate: (db, version) {
      db.execute(Tables.UER_TABLE);
      db.execute(Tables.NOTE_TABLE);
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _init();
    return _database;
  }
}

class Tables {
  static final String USER = "users";
  static final String NOTE = "notes";

  static final String UER_TABLE = '''CREATE TABLE $USER ( 
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  password TEXT)''';

  static final String NOTE_TABLE = '''CREATE TABLE $NOTE ( 
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER,
  title TEXT,
  description TEXT,
  date TEXT,
  FOREIGN KEY (userId) REFERENCES $USER (id) ON UPDATE CASCADE ON DELETE CASCADE)''';
}
