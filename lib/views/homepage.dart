import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/errorview.dart';
import 'package:libretube/views/loadingview.dart';
import 'package:libretube/views/videoview.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utilities/youtube.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static late String searchQuery;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _editingcontroller;
  late VideoSearchList VideosSearched;
  late final ScrollController controller = ScrollController();
  @override
  void initState() {
    _editingcontroller = TextEditingController();
    _editingcontroller.addListener(_updateState);
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {}
    });

    super.initState();
  }

  void _updateState() {
    refresh();
  }

  Future fetch() async {
    setState(() async {
      VideosSearched = (await VideosSearched.nextPage())!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          body: returnFutureBuilder("Artemis 1"),
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
                    onChanged: (text) {
                      assignData(text);
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

  Future refresh() async {
    setState(() {
      assignData(_editingcontroller.toString());
    });
  }

  Widget BuildCards(BuildContext context, VideoSearchList? list) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
          itemCount: list?.length ?? 0 + 1,
          itemBuilder: (context, index) {
            if (list != null) {
              if (index < list.length) {
                return Card(
                    child: ListTile(
                        title: Text(list?.elementAt(index).title ?? ""),
                        subtitle:
                            Text(list?.elementAt(index).description ?? ""),
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Image.network(
                            list?.elementAt(index).thumbnails.standardResUrl ??
                                "",
                            height: 150.0,
                            width: 100.0,
                          ),
                        ),
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () async {
                          VideoInfo.comms =
                              await getComments(list?.elementAt(index));
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              // Populate static video info to be passed further
                              VideoInfo.ID =
                                  list?.elementAt(index).id.toString() ?? "";
                              VideoInfo.author =
                                  list?.elementAt(index).author ?? "";
                              VideoInfo.description =
                                  list?.elementAt(index).description ?? "";
                              VideoInfo.name =
                                  list?.elementAt(index).title ?? "";
                              VideoInfo.publishDate =
                                  list?.elementAt(index).publishDate;
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

  Future<VideoSearchList> assignData(String que) async {
    VideosSearched = await getSearch(que);
    return VideosSearched;
  }

  Widget returnFutureBuilder(String query) {
    return FutureBuilder<VideoSearchList>(
      future: assignData(query),
      builder: (BuildContext context, AsyncSnapshot<VideoSearchList> snapshot) {
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
