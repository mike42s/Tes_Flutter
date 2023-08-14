import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:tesflutter/modal/Profile.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'database.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Profile ( '
          // 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nama VARCHAR(255) ,'
          'noktp VARCHAR(255) PRIMARY KEY,'
          'fotodriver TEXT ,'
          'password VARCHAR(255) '
          ')');
    });
  }

  Future<Database> get database async {
    if (_database == null) {
      return await initDB();
    } else {
      return _database!;
    }
  }

  Future<List<Profile>> getData() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Profile");
    print("Hasil Query Get Data Profile : " + res.toString());
    List<Profile> dataList = [];
    for (int i = 0; i < res.length; i++) {
      final Profile x_data = Profile.fromJson(res[i]);
      dataList.add(x_data);
    }
    return dataList;
  }

  Future<Profile> getUser(String nama, String password) async {
    final db = await database;
    final res = await db.query('Profile',
        where: 'nama = ? AND password = ?',
        whereArgs: [nama, password],
        limit: 1);
    print("Hasil Query Get Data Profile : " + res.toString());
    List<Profile> dataList = [];
    for (int i = 0; i < res.length; i++) {
      final Profile x_data = Profile.fromJson(res[i]);
      dataList.add(x_data);
    }
    return dataList[0];
  }

  Future saveData(Profile FileSave) async {
    try {
      final db = await database;
      final res = await db.insert('Profile', FileSave.toJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);
      print("Hasil Query Save Data Profile: " + res.toString());
      return res;
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }
}
