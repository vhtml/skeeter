import 'package:flutter/material.dart';

class DiscoverRssList extends StatefulWidget {
  @override
  _DiscoverRssListState createState() => _DiscoverRssListState();
}

class _DiscoverRssListState extends State<DiscoverRssList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        Container(
          height: 2000,
          child: Text('订阅源'),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}