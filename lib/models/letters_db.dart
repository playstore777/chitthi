import 'package:sqflite/sqflite.dart';

import 'package:chitthi/models/letter.dart';

class LettersDB {
  static const String _databaseName = 'chitthi.db';
  static const _version = 1;

  Database? database;
  static const tableName = 'chitthiyan';

  initDatabase() async {
    print('database name: $_databaseName');
    database = await openDatabase(_databaseName, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    FirstLine TEXT,
                    MainContent TEXT,
                    SentAt INT
                    )''');
    });
  }

  Future<int> insertLetter(Letter letter) async {
    var result = await database!
        .query(tableName, where: 'SentAt >= ?', whereArgs: [letter.sentAt]);
    print('database result: $result');
    if (result.isNotEmpty) {
      print('from database: data already exists');
      return 0;
    }
    return await database!.insert(tableName, letter.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateLetter(Letter letter) async {
    return await database!.update(tableName, letter.toMap(),
        where: 'id = ?',
        whereArgs: [letter.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllLetters() async {
    return await database!.query(tableName);
  }

  Future<Map<String, dynamic>?> getLetters(int id) async {
    var result =
        await database!.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }
  }

  Future<int> deleteLetter(int id) async {
    return await database!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  closeDatabase() async {
    await database!.close();
  }
}
