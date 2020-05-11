import 'dart:async';

import 'package:sqflite/sql.dart';
import 'package:stickynotes/app/app_database.dart';
import 'package:stickynotes/model/note.dart';

abstract class NoteServiceModel {
  Future<int> insert(Note note);

  Future<int> delete(int id);

  Future<void> notifyDataSetChange();
}

class NoteService implements NoteServiceModel {
  final AppDatabase appDatabase;
  final int userId;

  NoteService(this.appDatabase, this.userId);

  final _noteController = StreamController<List<Note>>.broadcast();

  Stream<List<Note>> get noteStream {
    notifyDataSetChange();
    return _noteController.stream;
  }

  @override
  Future<void> notifyDataSetChange() async {
    final notes = await _retrieve();
    _noteController.sink.add(notes);
  }

  @override
  Future<int> delete(int id) async {
    final database = await appDatabase.database;
    try {
      return await database
          .delete(Tables.NOTE, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  Future<int> insert(Note note) async {
    final database = await appDatabase.database;
    try {
      return await database.insert(Tables.NOTE, note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<Note>> _retrieve() async {
    final database = await appDatabase.database;
    try {
      final List<Map<String, dynamic>> maps = await database
          .query(Tables.NOTE, where: "userId = ?", whereArgs: [userId]);
      if (maps == null)
        return null;
      else {
        return List.generate(maps.length, (i) {
          return Note(
              id: maps[i]["id"],
              userId: maps[i]["userId"],
              title: maps[i]["title"],
              description: maps[i]["description"],
              date: maps[i]["date"]);
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void dispose() {
    _noteController.close();
  }
}
