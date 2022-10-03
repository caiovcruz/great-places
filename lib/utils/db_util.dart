import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE places (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();

    return await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> select(String table) async {
    final db = await DbUtil.database();

    return await db.query(table);
  }
}
