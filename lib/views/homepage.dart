import 'package:animation_search_bar/animation_search_bar.dart';
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

  @override
  void initState() {
    var focusNode = FocusNode();
    _editingcontroller = TextEditingController();
    controller.addListener(() async {
      if (controller.position.atEdge &&
          !(controller.position.pixels == 0) &&
          !HomePage.loadingState) {
        await fetch();
        print("Load more data");
      }
    });

    super.initState();
  }

  Future fetch() async {
    HomePage.loadingState = true;
    await appendToSearchList(VideosSearched);
    HomePage.loadingState = false;
    setState(() {});
  }

  Future<List<Video>> assignData(String que) async {
    List<Video> myVideoList = [];
    VideosSearched = await getSearch(que);
    var videoIterator = VideosSearched.iterator;
    while (videoIterator.moveNext()) {
      myVideoList.add(videoIterator.current);
    }
    VideosSearchedList = myVideoList;
    return myVideoList;
  }

  Future<bool> _updateState() async {
    try {
      HomePage.loadingState = true;
      HomePage.searchQuery = _editingcontroller.text;
      VideosSearched = await getSearch(HomePage.searchQuery);
      VideosSearchedList = await assignData(HomePage.searchQuery);

      setState(() {});
      HomePage.loadingState = false;
      return true;
    } on Exception catch (e) {
      print("Error: ${e.toString()}");
      return true;
    }
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
          body: returnFutureBuilder(HomePage.searchQuery),
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
                child: AnimationSearchBar(
                    isBackButtonVisible: true,
                    previousScreen: HomePage(),
                    backIconColor: Colors.black,
                    centerTitle: "LibreTube",
                    centerTitleStyle: GoogleFonts.sacramento(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                    //? Search hint text
                    hintStyle: GoogleFonts.sacramento(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                    //? Search Text
                    textStyle: GoogleFonts.sacramento(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                    onChanged: (text) async {
                      if (text == "mamma") {
                        HomePage.searchQuery = _editingcontroller.text;
                        await _updateState();
                      }
                    },
                    searchTextEditingController: _editingcontroller,
                    horizontalPadding: 5),
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
        await _updateState();
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
                          child: 
                            FadeInImage(
  placeholder: MemoryImage(Icons.sp),
  image: NetworkImageWithRetry(
    list.elementAt(index).thumbnails.standardResUrl
  ),
  fit: BoxFit.cover,
  fadeInDuration: Duration(milliseconds: 150)
),
                          // Image.network(
                          //   list.elementAt(index).thumbnails.standardResUrl,
                          //   height: 150.0,
                          //   width: 100.0,
                          //   errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                          //     return Text('Your error widget...');
                          //   },
                          // ),
                        ),
                        trailing: const Icon(Icons.play_arrow),
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

  Widget returnFutureBuilder(String query) {
    return FutureBuilder<List<Video>>(
      future: assignData(HomePage.searchQuery),
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
