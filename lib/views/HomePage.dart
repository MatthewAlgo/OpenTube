import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image/network.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/DiscoverView.dart';
import 'package:libretube/views/TrendingView.dart';
import 'package:libretube/views/ErrorView.dart';
import 'package:libretube/views/LoadingView.dart';
import 'package:libretube/views/MainView.dart';
import 'package:libretube/views/SubscriptionsView.dart';
import 'package:libretube/video/VideoView.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utilities/YouTube.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String searchQuery = "";
  static bool loadingState = false; // Acts like a pseudo-mutex

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int selectedpage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          body: PageView(
            controller: _pageController,
            children: <Widget>[
              MainView(),
              TrendingView(),
              DiscoverView(),
              SubscriptionsView()
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.trending_up_rounded, title: 'Trending'),
              TabItem(icon: Icons.map, title: 'Discover'),
              TabItem(icon: Icons.subscriptions, title: 'Subscriptions'),
            ],
            initialActiveIndex: selectedpage,
            onTap: (int index) {
              setState(() {
                _pageController.jumpToPage(index);
              });
            },
          )),
    );
  }
}