import 'package:skeeter/db/db_provider.dart';
import 'package:skeeter/models/single_rss_model.dart';
import 'package:sqflite/sqflite.dart';

class RssDao extends BaseDBProvider {
  // 表名
  final String name = 'rss';
  
  final String columnId = 'id';
  final String columnIconUrl = 'icon_url';
  final String columnTitle = 'title';
  final String columnLink = 'link';
  final String columnLastBuildDate = 'last_build_date';
  final String columnCreatedAt = 'created_at';

  RssDao();

  @override
  createTableString() {
    return '''
      CREATE TABLE $name (
        $columnId INTEGER PRIMARY KEY,
        $columnIconUrl TEXT,
        $columnTitle TEXT,
        $columnLink TEXT UNIQUE not NULL,
        $columnLastBuildDate TEXT,
        $columnCreatedAt int not NULL
      )
    ''';
  }

  @override
  tableName() {
    return name;
  }

  // 查询所有数据
  Future<List<SingleRss>> queryAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(tableName());
    List<SingleRss> rssList = maps.map<SingleRss>((el) => SingleRss.fromJson(el)).toList();
    return rssList;
  }

  // 根据url查询数据
  Future _queryByUrl(String url) async {
    if (url.isEmpty) {
      return null;
    }

    Database db = await getDatabase();
    String host = Uri.parse(url).host;
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM $name WHERE $columnLink Like '%$host%' LIMIT 1");
    return maps;
  }

  // 插入数据
  Future<int> insert(SingleRss rss) async {
    var res = await _queryByUrl(rss.link ?? '');

    if (res == null || res.length == 0) {
      Database db = await getDatabase();
      
      int id = await db.rawInsert('''
          INSERT INTO $name (
            $columnIconUrl,
            $columnTitle,
            $columnLastBuildDate,
            $columnLink,
            $columnCreatedAt
          ) values (?, ?, ?, ?, ?)
        ''',
        [rss.iconUrl, rss.title, rss.lastBuildDate, rss.link, DateTime.now().millisecondsSinceEpoch]
      );

      return id;
    }

    return res[0].id;
  }

  // update title
  Future<int> updateTitle(SingleRss oldRss, newTitle) async {
    Database db = await getDatabase();
    int count = await db.rawUpdate('UPDATE $name SET $columnTitle = ? WHERE $columnId = ?', [newTitle, oldRss.id]);
    return count;
  }

  // 删除数据
  Future<int> delete(int id) async {
    Database db = await getDatabase();
    return await db.delete(name, where: '$columnId = ?', whereArgs: [id]);
  }
}