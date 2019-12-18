import 'package:flutter/material.dart';
import 'discover_hot_list.dart';
import 'discover_rss_list.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin  {
  final List<Tab> _tabs = <Tab>[
    Tab(text: '今日热门'),
    Tab(text: '订阅源'),
  ];

  final List<Widget> _children = <Widget>[
    DiscoverHotList(),
    DiscoverRssList(),
  ];

  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // _tabController.addListener(() {
    //   var index = _tabController.index;
    //   var previewIndex = _tabController.previousIndex;
    //   print('index:$index, preview:$previewIndex');
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: TabBar(
            controller: _tabController,
            tabs: _tabs
          )
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: _children
          )
        )
      ]
    );
  }
}