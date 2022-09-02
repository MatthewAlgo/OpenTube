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
import 'package:libretube/views/DiscoveryView.dart';
import 'package:libretube/views/ErrorView.dart';
import 'package:libretube/views/LoadingView.dart';
import 'package:libretube/views/SubscriptionsView.dart';
import 'package:libretube/video/VideoView.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_data_api/models/video_data.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utilities/YouTube.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  static String searchQuery = "";
  static bool loadingState = false; // Acts like a pseudo-mutex

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final _editingcontroller;
  late VideoSearchList VideosSearched;
  late List<Video> VideosSearchedList;
  final ScrollController controller = ScrollController();
  bool comingFromFetch = false;

  @override
  void initState() {
    var focusNode = FocusNode();
    _editingcontroller = TextEditingController();
    controller.addListener(() async {
      if (controller.position.atEdge &&
          !(controller.position.pixels == 0) &&
          !MainView.loadingState) {
        await _fetchNewData();
        print("Load more data");
      }
    });
    super.initState();
  }

  Future _fetchNewData() async {
    MainView.loadingState = true;
    VideosSearched = await appendToSearchList(VideosSearched);
    VideosSearchedList = assignData();
    MainView.loadingState = false;
    comingFromFetch = true;
    setState(() {});
  }

  List<Video> assignData() {
    List<Video> myVideoList = [];
    var videoIterator = VideosSearched.iterator;
    while (videoIterator.moveNext()) {
      myVideoList.add(videoIterator.current);
    }
    VideosSearchedList = myVideoList;
    return myVideoList;
  }

  Future<List<Video>> _updateState() async {
    try {
      MainView.loadingState = true;
      if (!comingFromFetch) {
        MainView.searchQuery = _editingcontroller.text ?? "";
        VideosSearched = await getSearch(MainView.searchQuery, context);
        VideosSearchedList = assignData();
      } else {
        comingFromFetch = false;
      }
      MainView.loadingState = false;
      return VideosSearchedList;
    } on Exception catch (e) {
      print("Error: ${e.toString()}");
      return VideosSearchedList;
    }
  }

  Future<List<Video>> _refreshPage() async {
    setState(() {
      VideosSearchedList.length;
    });
    return VideosSearchedList;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: returnFutureBuilder(),
        appBar: PreferredSize(
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
                children: <Widget>[
                  AnimSearchBar(
                    suffixIcon: Icon(Icons.send),
                    prefixIcon: Icon(Icons.search_outlined),
                    width: MediaQuery.of(context).size.width,
                    textController: _editingcontroller,
                    onSuffixTap: () {
                      setState(() {
                        _updateState();
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
                  )
                ],
              ),
            ))),
      ),
    );
  }

  Widget BuildCards(BuildContext context, List<Video>? list) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refreshPage();
      },
      child: ListView.builder(
          controller: controller,
          itemCount: list?.length ?? 0 + 1,
          itemBuilder: (context, index) {
            if (list != null) {
              if (index < list.length) {
                return Card(
                    child: ListTile(
                        title: Text(list.elementAt(index).title,
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(list.elementAt(index).description ?? "",
                            style: GoogleFonts.dmSans()),
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                list.elementAt(index).thumbnails.standardResUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        trailing: Builder(builder: (context) {
                          return Column(
                            children: [
                              const SizedBox(
                                child: Icon(Icons.play_arrow),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: const SizedBox(
                                  child: Icon(Icons.bookmark),
                                ),
                              )
                            ],
                          );
                        }),
                        onTap: () async {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              // Populate static video info to be passed further
                              VideoInfo.video = list.elementAt(index);
                              // Other elements to be easier to access
                              VideoInfo.ID =
                                  list.elementAt(index).id.toString() ?? "";
                              VideoInfo.author =
                                  list.elementAt(index).author ?? "";
                              VideoInfo.description = list
                                      .elementAt(index)
                                      .description
                                      .characters
                                      .string ??
                                  "";
                              VideoInfo.name =
                                  list.elementAt(index).title ?? "";
                              VideoInfo.publishDate =
                                  list.elementAt(index).publishDate;
                              VideoInfo.channelID =
                                  list.elementAt(index).channelId;
                              VideoInfo.isLive = list.elementAt(index).isLive;
                              VideoInfo.keywords =
                                  list.elementAt(index).keywords;

                              return const VideoView();
                            }),
                          );
                        }));
              }
            }
            return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()));
          }),
    );
  }

  Widget returnFutureBuilder() {
    return FutureBuilder<List<Video>>(
      future: _updateState(),
      builder: (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const ErrorView();
          } else if (snapshot.hasData) {
            return BuildCards(context, snapshot.data);
          } else {
            return BuildCards(context, snapshot.data);
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
