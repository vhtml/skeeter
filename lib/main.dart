import 'package:flutter/material.dart';
import 'routes/feed_detail.dart';
import 'routes/feed_list.dart';
import 'routes/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skeeter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        primaryIconTheme: IconThemeData(color: Colors.black),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.black, fontFamily: 'Aveny')
        ),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.black)
        )
      ),
      routes: {
        FeedListRoute.routeName: (context) => FeedListRoute(rss: ModalRoute.of(context).settings.arguments),
        FeedDetailRoute.routeName: (context) => FeedDetailRoute(),
        HomeRoute.routeName: (context) => HomeRoute(),
      },
    );
  }
}
