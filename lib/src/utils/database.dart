import 'package:scoreboard_service/shelf.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {

  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(r'''CREATE TABLE Item (
          id INTEGER PRIMARY KEY,
          name TEXT,
          score INTEGER
          )''');
      }
    );
  }
}