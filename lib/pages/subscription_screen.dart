import 'package:flutter/material.dart';
import '../models/rss_item_model.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) => ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            dummyData[i].avatarUrl,
            width: 30,
            height: 30
          )
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 240.0,
              child: Text(dummyData[i].title, overflow: TextOverflow.ellipsis)
            ),
            Text(dummyData[i].unReadCount.toString(), style: TextStyle(color: Colors.grey, fontSize: 14.0))
          ],
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}