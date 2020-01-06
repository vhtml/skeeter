import 'package:flutter/material.dart';

class FeedDetailRoute extends StatelessWidget {
  static const routeName = '/feed_detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("feed detail"),
      ),
      body: Center(
        child: Text("This is Feed Detail"),
      ),
    );
  }
}