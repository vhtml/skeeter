import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeeter/common/funcs.dart';
import 'package:html/dom.dart' as dom;

class FeedDetailRoute extends StatelessWidget {
  static const routeName = '/feed_detail';
  
  final args;

  const FeedDetailRoute({Key key, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var feed = args.feed;
    var rss = args.rss;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        children: <Widget>[
          // 头部meta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(rss.title, style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey
              )),
              Text(pubDateFormat(feed.pubDate), style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey
              )),
            ]
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              feed.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0, color: Colors.black)
            )
          ),
          // Text(feed.content),
          Container(
            child: Html(
              data: feed.content ?? feed.description,
              onLinkTap: (url) {
                print(url);
              },
              onImageTap: (src) {
                print(src);
              },
              customTextStyle: (dom.Node node, TextStyle baseStyle) {
                if (node is dom.Element) {
                  switch (node.localName) {
                    case "h4":
                    case "h6":
                      return baseStyle.merge(TextStyle(fontWeight: FontWeight.bold));
                  }
                }
                return baseStyle;
              },
            )
          )
        ]
      )
    );
  }
}