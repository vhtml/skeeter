import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        Center(child: Text('我的页面'),)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}