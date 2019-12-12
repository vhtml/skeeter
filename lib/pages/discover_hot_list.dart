import 'package:flutter/material.dart';

class DiscoverHotList extends StatefulWidget {
  @override
  _DiscoverHotListState createState() => _DiscoverHotListState();
}

class _DiscoverHotListState extends State<DiscoverHotList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        Container(
          height: 2000,
          child: Text('今日热门'),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}