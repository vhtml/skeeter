import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  // 数据库版本
  static const int _VERSION = 1;

  // 数据库名称
  static const _DB_NAME = 'skeeter.db';

  // 数据库实例
  static Database _db;

  static initDb() async {
    String path = join(await getDatabasesPath(), _DB_NAME);
    _db = await openDatabase(path, version: _VERSION, onCreate: (Database db, int version) async {
      // 将创建表的功能分离到各个表类中，进行解耦，这里不再创建表
    });
  }

  static Future<Database> getCurrentDatabase() async {
    if (_db == null) {
      await initDb();
    }
    return _db;
  }

  // 判断指定表是否存在
  static isTableExists(String tableName) async {
    var db = await getCurrentDatabase();
    String sql = "SELECT * FROM Sqlite_master where type = 'table' and name = '$tableName'";
    var res = await db.rawQuery(sql);
    return res != null && res.length > 0;
  }

  static close() {
    _db?.close();
    _db = null;
  }
}