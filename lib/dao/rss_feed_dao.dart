import 'package:skeeter/db/db_provider.dart';
import 'package:skeeter/models/single_rss_feed_model.dart';
import 'package:sqflite/sqflite.dart';

class RssFeedDao extends BaseDBProvider {
  // 表名
  final String name = 'rss_feed';

  final String columnId = 'id';
  final String columnRssId = 'rss_id';
  final String columnTitle = 'title';
  final String columnAuthor = 'author';
  final String columnDescription = 'description';
  final String columnContent = 'content';
  final String columnPubDate = 'pub_date';
  final String columnLink = 'link';
  final String columnImages = 'images';
  final String columnCreatedAt = 'created_at';

  RssFeedDao();


  @override
  createTableString() {
    return '''
      CREATE TABLE $name (
        $columnId INTEGER PRIMARY KEY,
        $columnRssId INTEGER,
        $columnTitle TEXT,
        $columnAuthor TEXT,
        $columnDescription TEXT,
        $columnContent TEXT,
        $columnPubDate TEXT not NULL,
        $columnLink TEXT not NULL,
        $columnImages TEXT,
        $columnCreatedAt int not NULL
      )
    ''';
  }

  @override
  tableName() {
    return name;
  }

  // 查询所有数据
  Future<List<SingleRssFeed>> queryAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(tableName());
    List<SingleRssFeed> rssList = maps.map<SingleRssFeed>((el) => SingleRssFeed.fromJson(el)).toList();
    return rssList;
  }

  // 查询指定rss下的数据
  Future<List<SingleRssFeed>> queryByRssId(rssId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $name WHERE rss_id = ?', [rssId]);
    List<SingleRssFeed> rssList = maps.map<SingleRssFeed>((el) => SingleRssFeed.fromJson(el)).toList();
    return rssList;
  }

  // 插入数据
  insert(SingleRssFeed rssFeed, batch) async {
    batch.rawUpdate('''
        UPDATE $name SET
          $columnTitle = ?,
          $columnAuthor = ?,
          $columnDescription = ?,
          $columnContent = ?,
          $columnPubDate = ?,
          $columnImages = ?
          WHERE $columnLink = ?
      ''',
      [rssFeed.title, rssFeed.author, rssFeed.description, rssFeed.content, rssFeed.pubDate, rssFeed.images, rssFeed.link]
    );

    batch.rawInsert('''
        INSERT INTO $name (
          $columnRssId,
          $columnTitle,
          $columnAuthor,
          $columnDescription,
          $columnContent,
          $columnPubDate,
          $columnLink,
          $columnImages,
          $columnCreatedAt
        ) SELECT ?, ?, ?, ?, ?, ?, ?, ?, ? WHERE (Select Changes() = 0)
      ''',
      [rssFeed.rssId, rssFeed.title, rssFeed.author, rssFeed.description, rssFeed.content, rssFeed.pubDate, rssFeed.link, rssFeed.images, DateTime.now().millisecondsSinceEpoch]
    );
  }

  // 批量插入数据
  batchInsert(List<SingleRssFeed> feeds) async {
    Database db = await getDatabase();
    var batch = db.batch();
    feeds.forEach((feed) => insert(feed, batch));
    var results = batch.commit(continueOnError: true);
    print(results);
  }
}