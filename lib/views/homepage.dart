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
import 'package:libretube/views/errorview.dart';
import 'package:libretube/views/loadingview.dart';
import 'package:libretube/views/videoview.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utilities/youtube.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String searchQuery = "";
  static bool loadingState = false; // Acts like a pseudo-mutex

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          !HomePage.loadingState) {
        await _fetchNewData();
        print("Load more data");
      }
    });
    super.initState();
  }

  Future _fetchNewData() async {
    HomePage.loadingState = true;
    VideosSearched = await appendToSearchList(VideosSearched);
    VideosSearchedList = assignData();
    HomePage.loadingState = false;
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
      HomePage.loadingState = true;
      if (!comingFromFetch) {
        HomePage.searchQuery = _editingcontroller.text ?? "";
        VideosSearched = await getSearch(HomePage.searchQuery, context);
        VideosSearchedList = assignData();
      } else {
        comingFromFetch = false;
      }
      HomePage.loadingState = false;
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
          body: returnFutureBuilder(),
          appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 65),
              child: SafeArea(
                  child: Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 5))
                ]),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget> [
                    AnimSearchBar(
                      suffixIcon: Icon(Icons.send),
                      prefixIcon: Icon(Icons.search_outlined),
                      width: 400,
                      textController: _editingcontroller,
                      onSuffixTap: () {
                        setState(() {
                          _updateState();
                        });
                      },
                    ),
                    Expanded(
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("LibreTube", maxLines: 1, style: GoogleFonts.sacramento(fontSize: 30), overflow: TextOverflow.fade,),
                      )),
                    ),
                  ],
                ),
              ))),
          bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.map, title: 'Discovery'),
              TabItem(icon: Icons.people, title: 'Profile'),
            ],
            initialActiveIndex: 0, //optional, default as 0
            onTap: (int i) => print('click index=$i'),
          )),
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
                        title: Text(list.elementAt(index).title),
                        subtitle: Text(list.elementAt(index).description ?? ""),
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
                          return const SizedBox(
                            child: Icon(Icons.play_arrow),
                          );
                        }),
                        onTap: () async {
                          VideoInfo.comms =
                              await getComments(list.elementAt(index));
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              // Populate static video info to be passed further
                              VideoInfo.ID =
                                  list.elementAt(index).id.toString() ?? "";
                              VideoInfo.author =
                                  list.elementAt(index).author ?? "";
                              VideoInfo.description =
                                  list.elementAt(index).description ?? "";
                              VideoInfo.name =
                                  list.elementAt(index).title ?? "";
                              VideoInfo.publishDate =
                                  list.elementAt(index).publishDate;
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

class VideoInfo {
  static late String name;
  static late String ID;
  static late String author;
  static late List<String> comments;
  static late String description;
  static late DateTime? publishDate;
  static late CommentsList? comms;
}
