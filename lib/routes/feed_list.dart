import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skeeter/common/funcs.dart';
import 'package:skeeter/dao/rss_feed_dao.dart';
import 'package:skeeter/models/single_rss_feed_model.dart';
import 'package:skeeter/models/single_rss_model.dart';

class FeedListRoute extends StatefulWidget {
  static const routeName = '/feed_list';
  final SingleRss rss;

  FeedListRoute({Key key, this.rss, }) : super(key: key);

  @override
  _FeedListRouteState createState() => _FeedListRouteState();
}

class _FeedListRouteState extends State<FeedListRoute> {
  List<SingleRssFeed> _feeds = [];

  Future<List<SingleRssFeed>> getFeeds() async {
    var rssFeedDao = RssFeedDao();
    var feeds = await rssFeedDao.queryByRssId(widget.rss.id);
    setState(() {
      _feeds = feeds ?? [];
    });
    print(widget.rss.title + ':' + feeds.length.toString());
    return feeds;
  }

  @override
  void initState() {
    super.initState();
    getFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.rss.title),
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: _feeds.length,
        itemBuilder: (context, i) {
          var feed = _feeds[i];
          return FeedListItem(
            id: feed.id,
            title: feed.title,
            description: feed.description,
            pubDate: feed.pubDate,
            image: feed.images.split('|')[0] ?? '',
          );
        }
      )
    );
  }
}

class FeedListItem extends StatelessWidget {
  const FeedListItem({
    this.id,
    this.title,
    this.description,
    this.pubDate,
    this.image
  });

  final int id;
  final String title;
  final String description;
  final String pubDate;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _FeedDescription(
              title: title,
              description: description,
              pubDate: pubDateFormat(pubDate)
            ),
          ),
          _Thumbnail(image: image)
        ]
      )
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({this.image});

  final String image;
  
  @override
  Widget build(BuildContext context) {
    if (this.image.isEmpty) {
      return Text('');
    }
    
    return Container(
      width: 90.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(image),
        )
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
    );
  }
}

class _FeedDescription extends StatelessWidget {
  const _FeedDescription({
    Key key,
    this.title,
    this.description,
    this.pubDate
  }) : super(key: key);

  final String title;
  final String description;
  final String pubDate;

  String _formatText(String text) {
    var formattedText = text.replaceAll(new RegExp(r'<[^>]+>'), '');
    return formattedText.substring(0, min(100, formattedText.length));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            )
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            _formatText(description),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey
            )
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            pubDate,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey
            )
          ),
        ],
      )
    );
  }
}
