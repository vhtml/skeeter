import '../db/db_provider.dart';
import '../models/rss_item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssDao extends BaseDBProvider {
  // 表名
  final String name = 'rss';
  
  final String columnId = 'id';
  final String columnIconUrl = 'icon_url';
  final String columnTitle = 'title';
  final String columnLink = 'link';
  final String columnLastBuildDate = 'last_build_date';
  final String columnCreatedAt = 'created_at';

  static final RegExp urlReg = RegExp(r'^https?:\/\/');

  RssDao();

  @override
  createTableString() {
    return '''
        CREATE TABLE $name (
          $columnId INTEGER PRIMARY KEY,
          $columnIconUrl TEXT,
          $columnTitle TEXT,
          $columnLink TEXT not NULL,
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
  Future queryAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(tableName());
    List<RssItemModel> rssList = maps.map<RssItemModel>((el) => RssItemModel.fromJson(el)).toList();
    return rssList;
  }

  // 根据url查询数据
  Future queryByUrl(String url) async {
    Database db = await getDatabase();
    String origin = Uri.parse(url).origin;
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM $name WHERE $columnLink Like '%$origin%'");
    return maps;
  }

  // 插入数据
  Future insert(RssItemModel rss) async {
    Database db = await getDatabase();
    var res = await queryByUrl(rss.link);

    if (res == null || res.length == 0) {
      return await db.rawInsert('''
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
    }
  }

  static _normalizeUrl(String url) {
    if (!url.contains('.')) {
      return null;
    }

    if (!urlReg.hasMatch(url)) {
      return 'http://${url.trim()}';
    }
    
    return url;
  }

  // http拉取数据
  static Future<RssItemModel> fetch(rssLink) async {
    var link = _normalizeUrl(rssLink);

    try {
      final response = await http.get(link);
      var rss = RssFeed.parse(response.body);
      return RssItemModel(
        iconUrl: rss.image?.url,
        title: rss.title,
        link: link,
        lastBuildDate: rss.lastBuildDate
      );
    } catch (e) {
      print(e);
    }
    return null;
  }
}