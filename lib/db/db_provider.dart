import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import 'db_manager.dart';

abstract class BaseDBProvider {
  bool isTableExists = false;

  createTableString();

  tableName();
  
  // 创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDatabase() async {
    return await open();
  }

  // super函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExists = await DBManager.isTableExists(name);
    if (!isTableExists) {
      Database db = await DBManager.getCurrentDatabase();
      db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExists) {
      await prepare(tableName(), createTableString());
    }
    return await DBManager.getCurrentDatabase();
  }
}