import 'package:flutter/material.dart';
import 'pages/discover_screen.dart';
import 'pages/subscription_screen.dart';
import 'pages/user_screen.dart';
import 'common/funcs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SubscriptionScreen(),
    DiscoverScreen(),
    UserScreen(),
  ];
  final pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skeeter'),
        elevation: 1,
        centerTitle: false,
        actions: _buildAppBarActions(),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: _children,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: _buildBottomNavigationBar()
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_currentIndex == 2) {
      return [];
    }

    if (_currentIndex == 1) {
      return [
        _buildAddRssButton(),
        _buildSearchRssButton()
      ];
    }

    return [
      _buildRefreshButton(),
      _buildAllListButton(),
      _buildAddRssButton(),
    ];
  }

  IconButton _buildRefreshButton() {
    return IconButton(
      icon: Icon(Icons.autorenew),
      onPressed: () {}
    );
  }

  IconButton _buildAllListButton() {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {}
    );
  }

  IconButton _buildAddRssButton() {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        var result = await showAddRssDialog(context);
        print(result);
      }
    );
  }

  IconButton _buildSearchRssButton() {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {}
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.rss_feed),
          title: Text('阅读'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('发现')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('我的')
        )
      ],
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.amber[800]
    );
  }
}
