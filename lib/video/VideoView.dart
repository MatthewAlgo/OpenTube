import 'dart:collection';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/HomePage.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late TextEditingController _seekToController;
  late TextEditingController _editingcontroller;
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: VideoInfo.ID,
  );
  late bool autoPlay;

  @override
  void initState() {
    _editingcontroller = TextEditingController();
    autoPlay = true;
    _controller = YoutubePlayerController(
      initialVideoId: VideoInfo.ID,
    );
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: videoAppBody(),
          appBar: MediaQuery.of(context).orientation == Orientation.landscape
              ? null // show nothing in lanscape mode
              : PreferredSize(
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
                          width: 400,
                          textController: _editingcontroller,
                          onSuffixTap: () {
                            // setState(() {
                            //   _updateState();
                            // });
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
                            Navigator.pop(context);
                          },
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.arrow_circle_right_rounded,
                            size: 35.0,
                          ),
                          shape: CircleBorder(),
                        )
                      ],
                    ),
                  ))),
        ));
  }

  Widget videoAppBody() {
    return Center(
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return Scaffold(
            body: Column(
              children: [
                player,
                Container(
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
                  child: Center(), // TODO: Get channel info
                ),
                Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonBar(
                        children: [
                          FloatingActionButton.extended(
                            label: Text(
                              'Download',
                              style: GoogleFonts.dmSans(fontSize: 12),
                            ), // <-- Text
                            backgroundColor: Colors.black,
                            icon: Icon(
                              // <-- Icon
                              Icons.download,
                              size: 12.0,
                            ),
                            onPressed: () {},
                          ),
                          FloatingActionButton.extended(
                            label: Text(
                              'Save',
                              style: GoogleFonts.dmSans(fontSize: 12),
                            ), // <-- Text
                            backgroundColor: Colors.black,
                            icon: Icon(
                              // <-- Icon
                              Icons.save,
                              size: 12.0,
                            ),
                            onPressed: () {},
                          ),
                          FloatingActionButton.extended(
                            label: Text(
                              'Download Audio',
                              style: GoogleFonts.dmSans(fontSize: 12),
                            ), // <-- Text
                            backgroundColor: Colors.black,
                            icon: Icon(
                              // <-- Icon
                              Icons.headphones,
                              size: 12.0,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      VideoInfo.name,
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      VideoInfo.description,
                      style: GoogleFonts.dmSans(),
                    ),
                  ),
                ),
                // TODO: Add Comments list for video
                // ListView.builder(
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   itemCount: VideoInfo?.comms?.length,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       child: Card(
                //         elevation: 9,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(30)),
                //         ),
                //         child: ListTile(
                //           dense: false,
                //           leading: FlutterLogo(),
                //           title: Text(
                //             VideoInfo.comms?.elementAt(index).author ?? "",
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold, fontSize: 20),
                //           ),
                //           subtitle: Text(
                //             VideoInfo.comms?.elementAt(index).text ?? "",
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold, fontSize: 16),
                //           ),
                //           trailing: Icon(Icons.arrow_forward_ios),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
            bottomNavigationBar:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? null // show nothing in lanscape mode
                    : ConvexAppBar(
                        items: [
                          TabItem(icon: Icons.play_arrow, title: 'Video'),
                          TabItem(icon: Icons.message, title: 'Comments'),
                        ],
                        initialActiveIndex: 0, //optional, default as 0
                        onTap: (int i) => print('click index=$i'),
                      ),
          );
        },
      ),
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
  static late ChannelId channelID;
  static late bool isLive;
  static late UnmodifiableListView<String> keywords;
}
