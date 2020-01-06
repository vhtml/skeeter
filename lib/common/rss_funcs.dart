import 'package:skeeter/dao/rss_dao.dart';
import 'package:skeeter/dao/rss_feed_dao.dart';
import 'package:skeeter/models/single_rss_feed_model.dart';
import 'package:skeeter/models/single_rss_model.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

final RegExp _urlReg = RegExp(r'^https?:\/\/');

String _normalizeUrl(String url) {
  if (url == null || !url.contains('.')) {
    return null;
  }

  if (!_urlReg.hasMatch(url)) {
    return 'http://${url.trim()}';
  }
  
  return url;
}

// http拉取数据
Future<RssFeed> _fetch(rssLink) async {
  var link = _normalizeUrl(rssLink);
  if (link == null) {
    return null;
  }

  try {
    final response = await http.get(link);
    RssFeed rss = RssFeed.parse(response.body);
    return rss;
  } catch (e) {
    print(e);
  }
  return null;
}

Future<void> _batchInsertFeed(rssFeed, parentRssId) async {
  List<SingleRssFeed> feeds = rssFeed.items.map<SingleRssFeed>((item) {
    return SingleRssFeed(
      rssId: parentRssId,
      title: item.title,
      author: item.author,
      description: item.description,
      content: item.content?.value,
      pubDate: item.pubDate,
      link: item.link,
      images: item.content?.images?.join('|') ?? '',
    );
  }).toList();

  var rssFeedDao = RssFeedDao();
  return await rssFeedDao.batchInsert(feeds);
}

Future<void> addRssWithFeeds(rssLink) async {
  var link = _normalizeUrl(rssLink);
  if (link == null) {
    return null;
  }

  var rss = await _fetch(link);
  if (rss != null) {
    var singleRss = SingleRss(
      iconUrl: rss.image?.url,
      title: rss.title == null || rss.title.isEmpty ? Uri.parse(link).host : rss.title,
      link: link,
      lastBuildDate: rss.lastBuildDate
    );

    var rssDao = RssDao();
    int parentRssId = await rssDao.insert(singleRss);

    if (parentRssId == null) return;
    _batchInsertFeed(rss, parentRssId);
  }
}

// 同步所有数据
Future<void> syncAllRssFeeds([List<SingleRss> rssList]) async {
  if (rssList == null) {
    var rssDao = RssDao();
    rssList = await rssDao.queryAll();
  }

  var rssFutures = rssList.map((rss) async {
    var rssFeed = await _fetch(rss.link);
    await _batchInsertFeed(rssFeed, rss.id);
  });

  Future.wait(rssFutures);
}