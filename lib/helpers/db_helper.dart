import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  String dbTable = 'my_transaction';
  String colId = 'id';
  static Future<sql.Database> dataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'transaction.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE my_transaction(id TEXT PRIMARY KEY,title TEXT, amount INTEGER, date TEXT)',
      );
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.dataBase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.dataBase();
    return db.query(table);
  }

  Future<int> delete(String id) async {
    var db = await DBHelper.dataBase();
    int result = await db.rawDelete('DELETE FROM $dbTable WHERE $colId=?');
    print(result);
    return result;
  }

  Future<int?> getCount() async {
    final db = await DBHelper.dataBase();
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $dbTable');
    int? result = sql.Sqflite.firstIntValue(x);
    return result;
  }
}
