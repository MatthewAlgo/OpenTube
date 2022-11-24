import 'dart:collection';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/data/Pair.dart';
import 'package:libretube/video/CommentsView.dart';
import 'package:libretube/video/SameUploaderView.dart';
import 'package:libretube/video/VideoInfoBottom.dart';
import 'package:libretube/views/connection/ErrorView.dart';
import 'package:libretube/views/HomePage.dart';
import 'package:libretube/views/connection/LoadingView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  VideoView({Key? key, required String this.videoId}) : super(key: key);

  final String videoId;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _seekToController;
  late TextEditingController _editingcontroller;
  late YoutubePlayerController _controller;
  late bool autoPlay;

  late List<exp.Video> videoData;
  late exp.CommentsList commentsList; 

  PageController _pageController = PageController(keepPage: true);

  @override
  bool get wantKeepAlive => true;

  // Change views in page bottom
  int selectedpage = 0;

  @override
  void initState() {
    VideoInfoBottomView.numberOfCallsFromTabChange = 0;
    _pageController = PageController();
    _editingcontroller = TextEditingController();
    autoPlay = true;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
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
    _pageController.dispose();
    _editingcontroller.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: _getVideoInformation(widget.videoId),
          builder: (BuildContext context,
              AsyncSnapshot<Pair<exp.Video, exp.Channel>> snapshot) {
            if (snapshot.hasData) {
              return MaterialApp(
                  theme: ThemeData(useMaterial3: true),
                  home: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: videoAppBody(),
                    appBar: MediaQuery.of(context).orientation ==
                            Orientation.landscape
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  AnimSearchBar(
                                    suffixIcon: Icon(Icons.send),
                                    prefixIcon: Icon(Icons.search_outlined),
                                    width: MediaQuery.of(context).size.width,
                                    textController: _editingcontroller,
                                    onSuffixTap: () {
                                      Navigator.pop(context);
                                      setState(() async {
                                        HomePage.editingController =
                                            _editingcontroller;
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
                                        style: GoogleFonts.sacramento(
                                            fontSize: 30),
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            } else if (snapshot.hasError) {
              // Print the error
              print("ErrorView: " + snapshot.error.toString());
              return const ErrorView();
            } else {
              return const ErrorView();
            }
          }),
    );
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
                child: PageView(
                  onPageChanged: (index) {
                    setState(() => selectedpage = index);
                  },
                  controller: _pageController,
                  children: <Widget>[
                    VideoInfoBottomView(vidIdent: widget.videoId),
                    CommentsView(commentsList: commentsList),
                    SimilarVideosView(videoRecommended: videoData),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? null // show nothing in lanscape mode
                  : BottomNavyBar(
                      backgroundColor: Colors.yellow.shade300,
                      selectedIndex: selectedpage,
                      onItemSelected: (index) {
                        setState(() => selectedpage = index);
                        _pageController.jumpToPage(index);
                        _pageController.animateToPage(index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      items: <BottomNavyBarItem>[
                        BottomNavyBarItem(
                            title: Text('Video Home'),
                            icon: Icon(Icons.home_rounded),
                            textAlign: TextAlign.center),
                        BottomNavyBarItem(
                            title: Text('Comments'),
                            icon: Icon(Icons.comment_rounded),
                            textAlign: TextAlign.center),
                        BottomNavyBarItem(
                            title: Text('Channel'),
                            icon: Icon(Icons.trending_up_rounded),
                            textAlign: TextAlign.center),
                      ],
                    ),
        );
      },
    );
  }

  Future<Pair<exp.Video, exp.Channel>> _getVideoInformation(
      String videoID) async {
    // Get video data from youtube explode
    exp.YoutubeExplode ytExplode = exp.YoutubeExplode();
    exp.Video video = await ytExplode.videos.get(videoID);

    exp.ChannelClient channelClient = exp.YoutubeExplode().channels;
    exp.Channel channel = await channelClient.getByVideo(video.id.toString());
    // Fetch list of videos from the channel
    List<exp.Video> videos =
        await ytExplode.channels.getUploads(channel.id).take(25).toList(); // 25 videos loaded
    // Fetch the list of comments for the video
    commentsList = (await ytExplode.videos.comments.getComments(video))!;

    videoData = videos;
    return Pair<exp.Video, exp.Channel>(video, channel);
  }
}
