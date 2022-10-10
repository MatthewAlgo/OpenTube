import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/DiscoverView.dart';
import 'package:libretube/views/TrendingView.dart';
import 'package:libretube/views/connection/ErrorView.dart';
import 'package:libretube/views/connection/LoadingView.dart';
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

  static TextEditingController editingController = TextEditingController();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int selectedpage = 0;

  PageController _pageController = PageController();
  ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  void initState() {
    _drawerController = ZoomDrawerController();
    HomePage.editingController = TextEditingController();
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    HomePage.editingController.dispose();
    _pageController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          appBar: buildHigherSearchBar(),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
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

  PreferredSizeWidget buildHigherSearchBar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: SafeArea(
            child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(0, 5))
              ],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimSearchBar(
                suffixIcon: Icon(Icons.send),
                prefixIcon: Icon(Icons.search_outlined),
                width: MediaQuery.of(context).size.width,
                textController: HomePage.editingController,
                onSuffixTap: () {
                  selectedpage = 0;
                  _pageController.jumpToPage(0); // Go to homepage and refresh
                  setState(() async {  
                    await _refreshPage();
                  });
                },
              ),
              Expanded(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "LibreTube",
                    maxLines: 1,
                    style: GoogleFonts.sacramento(fontSize: 30),
                    overflow: TextOverflow.fade,
                  ),
                )),
              ),
              RawMaterialButton(
                onPressed: () {
                  // Open a drawer or a view
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.menu,
                  size: 35.0,
                ),
                shape: CircleBorder(),
              ),
            ],
          ),
        )));
  }

  Future<void> _refreshPage() async {
    // Rebuild the widget
    MainView.wannaRebuild.value = true;
    MainView.wannaRebuild.value = false;
    MainView.init_counter_from_rebuild = 0;

    setState(() async {});
  }
}
