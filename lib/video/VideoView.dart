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
import 'package:hive/hive.dart';
import 'package:libretube/data/Pair.dart';
import 'package:libretube/utilities/LocalStorageRepo.dart';
import 'package:libretube/utilities/VideoUtil.dart';
import 'package:libretube/utilities/VideoUtilH.dart';
import 'package:libretube/video/CommentsView.dart';
import 'package:libretube/video/SameUploaderView.dart';
import 'package:libretube/video/VideoInfoBottom.dart';
import 'package:libretube/views/connection/ErrorView.dart';
import 'package:libretube/views/HomePage.dart';
import 'package:libretube/views/connection/LoadingView.dart';
import 'package:libretube/views/drawer/HistoryView.dart';
import 'package:libretube/views/drawer/SettingsView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  VideoView({Key? key, required String this.videoId}) : super(key: key);

  final String videoId;

  static int selectedpage = 0;

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
  late exp.CommentsList? commentsList;

  PageController _pageController =
      PageController(keepPage: true, initialPage: 0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    VideoInfoBottomView.numberOfCallsFromTabChange = 0;
    VideoView.selectedpage = 0;

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
        return FutureBuilder(
            future: _getVideoInformation(widget.videoId),
            builder: (BuildContext context,
                AsyncSnapshot<Pair<exp.Video, exp.Channel>> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  body: Column(
                    children: [
                      player,
                      Flexible(
                        child: PageView(
                          onPageChanged: (index) {
                            setState(() => VideoView.selectedpage = index);
                          },
                          controller: _pageController,
                          children: <Widget>[
                            VideoInfoBottomView(
                                vidIdent: widget.videoId,
                                videodata: snapshot.data!), // Can't be null
                            CommentsView(commentsList: commentsList),
                            SimilarVideosView(videoRecommended: videoData),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? null // show nothing in lanscape mode
                      : BottomNavyBar(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          selectedIndex: VideoView.selectedpage,
                          onItemSelected: (index) {
                            setState(() => VideoView.selectedpage = index);
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
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingView();
              } else if (snapshot.hasError) {
                // Print the error
                print("ErrorView: " + snapshot.error.toString());
                return const ErrorView();
              } else {
                return const ErrorView();
              }
            });
      },
    );
  }

  Future<Pair<exp.Video, exp.Channel>> _getVideoInformation(
      String videoID) async {
    if (VideoInfoBottomView.numberOfCallsFromTabChange == 0) {
      // Call this only once per video
      // Get video data from youtube explode
      exp.YoutubeExplode ytExplode = exp.YoutubeExplode();
      exp.Video video = await ytExplode.videos.get(videoID);

      exp.ChannelClient channelClient = exp.YoutubeExplode().channels;
      exp.Channel channel = await channelClient.getByVideo(video.id.toString());
      // Fetch list of videos from the channel
      List<exp.Video> videos = await ytExplode.channels
          .getUploads(channel.id)
          .take(25)
          .toList(); // 25 videos loaded
      // Fetch the list of comments for the video
      commentsList = await ytExplode.videos.comments.getComments(video);
      videoData = videos;

      // Add video to history
      AddVideoToHistory(video);
      return Pair<exp.Video, exp.Channel>(video, channel);
    } else {
      return Pair<exp.Video, exp.Channel>(
          VideoInfoBottomView.savedSnapshot!.getFirst(),
          VideoInfoBottomView.savedSnapshot!.getSecond());
    }
  }

  void AddVideoToHistory(exp.Video video) async {
    // Only add video to history if the user wants to
    if (SettingsView.IS_HISTORY_ENABLED) {
      VideoUtilH videoUtil = VideoUtilH(
        id: video.id.value,
        title: video.title.toString(),
        thumbnailURL: video.thumbnails.mediumResUrl.toString(),
        videoURL: video.url.toString(),
      );

      LocalStorageRepository localStorageRepository = LocalStorageRepository();
      Box box = await localStorageRepository.openBoxVideosHistory();
      localStorageRepository.addVideoHistorytoList(box, videoUtil);

      // Assign the channel lists
      HistoryView.listHistoryViewStatic =
          localStorageRepository.getVideosHistoryList(box);
      HistoryView.listHistoryViewStaticNotifier.value =
          HistoryView.listHistoryViewStatic;
    }else{
      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Video history is disabled"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
