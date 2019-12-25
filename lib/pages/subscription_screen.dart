import 'package:flutter/material.dart';
import 'package:skeeter/models/single_rss_model.dart';

class SubscriptionScreen extends StatelessWidget{
  final List<SingleRss> rssList;
  final Function updateTitle;
  final Function unsubscribe;
  final Function markAsRead;

  SubscriptionScreen({this.rssList, this.updateTitle, this.unsubscribe, this.markAsRead});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rssList.length,
      itemBuilder: (context, i) {
        var rssItem = rssList[i];
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
          ),
          onLongPress: () async {
            var command = await _showActionDialog(context, rssItem);

            switch (command) {
              case 'RENAME':
                var text = await _showRenameDialog(context, rssItem);
                if (text == null || text.trim().isEmpty) return;
                this.updateTitle(rssItem, text);
                break;
              case 'MARK':
                print('标记');
                break;
              case 'UNSUBSCRIBE':
                this.unsubscribe(rssItem);
            }
          }
        );
      }
    );
  }

  Future _showActionDialog(context, rssItem) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(rssItem.title),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, 'RENAME'); },
              child: const Text('重命名'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, 'MARK'); },
              child: const Text('标记为已读'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, 'UNSUBSCRIBE'); },
              child: const Text('取消订阅'),
            ),
          ],
        );
      }
    );
  }

  Future _showRenameDialog(context, rssItem) async {
    final controller = TextEditingController(text: rssItem.title);

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('重命名'),
          content: TextField(
            controller: controller,
            autofocus: true
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.pop(context, controller.text);
              }
            )
          ]
        );
      }
    );
  }
}