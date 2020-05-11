import 'package:sqflite/sqflite.dart';
import 'package:stickynotes/app/app_database.dart';
import 'package:stickynotes/model/user.dart';

abstract class AuthServiceModel {
  Future<int> register(User user);

  Future<User> authenticate(String username, String password);

  Future<bool> check(String username);
}

class AuthService implements AuthServiceModel {
  final AppDatabase _appDatabase;

  AuthService(this._appDatabase);

  @override
  Future<User> authenticate(String username, String password) async {
    final Database database = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT *FROM " + Tables.USER + " WHERE username=? and password=?",
        [username, password]);
    return (maps.length > 0) ? User.fromMap(maps[0]) : null;
  }

  @override
  Future<bool> check(String username) async {
    final Database database = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await database
        .query(Tables.USER, where: "username = ?", whereArgs: [username]);
    return maps.length > 0;
  }

  @override
  Future<int> register(User user) async {
    final Database database = await _appDatabase.database;
    return await database.insert(Tables.USER, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
