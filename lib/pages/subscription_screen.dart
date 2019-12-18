import 'package:flutter/material.dart';
import 'package:skeeter/dao/rss_dao.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with AutomaticKeepAliveClientMixin {
  var _rssList = [];

  @override
  void initState() {
    super.initState();
    getRssList().then((rssList) {
      setState(() {
        _rssList = rssList ?? [];
      });
    });
  }

  getRssList() async {
    var rssDao = RssDao();
    return await rssDao.queryAll();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: _rssList.length,
      itemBuilder: (context, i) {
        var rssItem = _rssList[i];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: rssItem.iconUrl != null? Image.network(
              rssItem.iconUrl,
              width: 30,
              height: 30
            ) : Icon(Icons.rss_feed)
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 240.0,
                child: Text(rssItem.title, overflow: TextOverflow.ellipsis)
              ),
              Text('10', style: TextStyle(color: Colors.grey, fontSize: 14.0))
            ],
          )
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}