import 'package:flutter/material.dart';
import '../common/rss_funcs.dart';
import '../dao/rss_dao.dart';
import '../models/single_rss_model.dart';
import '../pages/discover_screen.dart';
import '../pages/subscription_screen.dart';
import '../pages/user_screen.dart';
import '../common/funcs.dart';

class HomeRoute extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  List<SingleRss> _rssList = [];

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

  Future<List<SingleRss>> getRssList() async {
    var rssDao = RssDao();
    var rssList = await rssDao.queryAll();
    setState(() {
      _rssList = rssList ?? [];
    });
    return rssList;
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

    getRssList();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animController?.dispose();
    super.dispose();
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
        children: <Widget>[
          SubscriptionScreen(
            rssList: _rssList,
            updateTitle: _updateTitle,
            unsubscribe: _unsubscribe,
            markAsRead: _markAsRead
          ),
          DiscoverScreen(),
          UserScreen(),
        ],
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: _buildBottomNavigationBar()
    );
  }

  void _unsubscribe(rssItem) async {
    var rssDao = RssDao();
    var count = await rssDao.delete(rssItem.id);

    if (count > 0) {
      _rssList.removeWhere((item) => item.id == rssItem.id);
      setState(() {
        _rssList = _rssList;
      });
    }
  }

  void _updateTitle(rssItem, newTitle) async {
    var rssDao = RssDao();
    var count = await rssDao.updateTitle(rssItem, newTitle);

    if (count > 0) {
      _rssList.forEach((item) => {
        if (item.id == rssItem.id) {
          item.title = newTitle
        }
      });
      setState(() {
        _rssList = _rssList;
      });
    }
  }

  void _markAsRead(rssItem) {

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
        onPressed: () async {
          _animController.forward();
          var rssList = await getRssList();
          await syncAllRssFeeds(rssList);
          _animController.reset();
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

        _animController.forward(); // 动画开始
        
        await addRssWithFeeds(rssLink);

        await getRssList();
        _animController.reset(); // 动画结束并重置
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
