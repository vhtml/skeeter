import 'package:flutter/material.dart';
import 'dao/rss_dao.dart';
import 'models/single_rss_model.dart';
import 'pages/discover_screen.dart';
import 'pages/subscription_screen.dart';
import 'pages/user_screen.dart';
import 'common/funcs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SubscriptionScreen(),
    DiscoverScreen(),
    UserScreen(),
  ];
  final _pageController = PageController();
  AnimationController _animController;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 重置起点
        _animController.reset();
        //开始执行
        _animController.forward();
      }
    });
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
        controller: _pageController,
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

  Widget _buildRefreshButton() {
    return RotationTransition(
      alignment: Alignment.center,
      turns: _animController,
      child: IconButton(
        icon: Icon(Icons.autorenew),
        onPressed: () {
          _animController.forward();
        }
      )
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
        String rssLink = await showAddRssDialog(context);
        SingleRss singleRss = await RssDao.fetch(rssLink);
        
        if (singleRss == null) return;

        var rssDao = RssDao();
        rssDao.insert(singleRss);
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
