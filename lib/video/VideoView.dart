import 'dart:collection';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/video/SimilarVideosView.dart';
import 'package:libretube/video/VideoInfoBottom.dart';
import 'package:libretube/views/ErrorView.dart';
import 'package:libretube/views/HomePage.dart';
import 'package:libretube/views/LoadingView.dart';
import 'package:youtube_data_api/models/channel.dart' as chandata;
import 'package:youtube_data_api/models/video.dart' as viddata;
import 'package:youtube_data_api/models/video_data.dart';
import 'package:youtube_data_api/youtube_data_api.dart' as dapi;
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _seekToController;
  late TextEditingController _editingcontroller;
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: VideoInfo.ID,
  );
  late bool autoPlay;

  @override
  bool get wantKeepAlive => true;

  // Change views in page bottom
  int selectedpage = 0;
  final _pageNo = [VideoInfoBottomView(), SimilarVideosView()];

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
    super.build(context);
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
                          width: MediaQuery.of(context).size.width,
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          body: Column(
            children: [
              player,
              Flexible(
                child: IndexedStack(
                  children: <Widget>[
                    VideoInfoBottomView(),
                    SimilarVideosView(),
                  ],
                  index: selectedpage,
                ),
              ),
            ],
          ),
          bottomNavigationBar:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? null // show nothing in lanscape mode
                  : ConvexAppBar(
                      items: [
                        TabItem(icon: Icons.play_arrow, title: 'Now Playing'),
                        TabItem(
                            icon: Icons.video_library_rounded,
                            title: 'Similar Videos'),
                      ],
                      initialActiveIndex: selectedpage,
                      onTap: (int index) {
                        setState(() {
                          selectedpage = index;
                        });
                      },
                    ),
        );
      },
    );
  }
}

class VideoInfo {
  static late exp.Video video;
  static late String name;
  static late String ID;
  static late String author;
  static late exp.CommentsList comments;
  static late String description;
  static late DateTime? publishDate;
  static late exp.CommentsList? comms;
  static late exp.ChannelId channelID;
  static late bool isLive;
  static late UnmodifiableListView<String> keywords;
  static late chandata.Channel videoChannel;
  static late List<viddata.Video> relatedVideos;
}
