import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/ErrorView.dart';
import 'package:libretube/views/LoadingView.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_data_api/models/video_data.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utilities/YouTube.dart';
import 'VideoView.dart';

class VideoInfoBottomView extends StatefulWidget {
  const VideoInfoBottomView({Key? key}) : super(key: key);
  static int NumberOfCallsFromTabChange = 0;
  static late VideoData? PreservedVideoDataState;

  @override
  State<VideoInfoBottomView> createState() => _VideoInfoBottomViewState();
}

class _VideoInfoBottomViewState extends State<VideoInfoBottomView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    VideoInfoBottomView.NumberOfCallsFromTabChange++;

    if (VideoInfoBottomView.NumberOfCallsFromTabChange == 1) {
      return FutureBuilder<VideoData?>(
          future: fetchNetworkCall(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return getPageBody(context);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingView();
            } else {
              return ErrorView();
            }
          });
    } else {
      return getPageBody(context);
    }
  }
}

Future<VideoData?> fetchNetworkCall() async {
  YoutubeDataApi youtubeDataApi = YoutubeDataApi(); // To get channel data
  var YtExplode = YoutubeExplode();
  // We get the list of comments from the youtube server
  var VideoComments =
      await YtExplode.videos.comments.getComments(VideoInfo.video);
  print("VideoComments: ${VideoComments.toString()}");

  if (VideoInfo != null) {
    // We assign the data to the static variable
    VideoInfo.comms = VideoComments;

    // We call the youtubeDataApi on the same video
    VideoInfoBottomView.PreservedVideoDataState = await youtubeDataApi
        .fetchVideoData(VideoInfo.video.id.toString() ?? "");
    if (VideoInfoBottomView.PreservedVideoDataState != null) {
      // And get the list of similar videos
      VideoInfo.relatedVideos =
          VideoInfoBottomView.PreservedVideoDataState!.videosList; // Also fill the related videos
    }
    VideoInfoBottomView.PreservedVideoDataState =
        VideoInfoBottomView.PreservedVideoDataState!; // We fill the static variable
    return VideoInfoBottomView.PreservedVideoDataState;
  } else {
    throw Exception("VideoInfo is null");
  }
}

Widget getPageBody(BuildContext context) {
  return Scaffold(
    body: Container(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
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
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.thumb_up_alt_rounded),
                        ), // <-- Icon
                        Text(
                            VideoInfoBottomView
                                    .PreservedVideoDataState?.video!.likeCount ??
                                "",
                            style:
                                GoogleFonts.dmSans(fontSize: 12)), // <-- Text
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.play_circle),
                        ), // <-- Icon
                        Text(
                           VideoInfoBottomView
                                    .PreservedVideoDataState?.video!.viewCount ??
                                "",
                            style:
                                GoogleFonts.dmSans(fontSize: 12)), // <-- Text
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.publish),
                        ), // <-- Icon
                        Text(
                            VideoInfoBottomView
                                    .PreservedVideoDataState?.video!.date ??
                                "",
                            style:
                                GoogleFonts.dmSans(fontSize: 12)), // <-- Text
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Define the box for the share item
                      final box = context.findRenderObject() as RenderBox?;
                      await Share.share(
                        "https://www.youtube.com/watch?v=$VideoInfoBottomView.PreservedVideoDataState?.video.videoId}",
                        subject:
                            "https://www.youtube.com/watch?v=${VideoInfoBottomView.PreservedVideoDataState?.video!.videoId}",
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      );
                    },
                    child: SizedBox(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.share),
                          ), // <-- Icon
                          Text("Share",
                              style:
                                  GoogleFonts.dmSans(fontSize: 12)), // <-- Text
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Download, Save and Audio buttons
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
                          'Get Video',
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
                          'Get Audio',
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
            // Channel and video information
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(VideoInfoBottomView
                                .PreservedVideoDataState?.video!.channelThumb ??
                            ""),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                              VideoInfoBottomView.PreservedVideoDataState?.video!
                                      .channelName
                                      ?.toString() ??
                                  "",
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${VideoInfoBottomView.PreservedVideoDataState?.video?.subscribeCount ?? ""}',
                              style: GoogleFonts.dmSans()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        // <---  these 2 lines fixed it
                        alignment: Alignment
                            .centerRight, // <---  these 2 lines fixed it
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered))
                                      return Colors.blue.withOpacity(0.04);
                                    if (states
                                            .contains(MaterialState.focused) ||
                                        states.contains(MaterialState.pressed))
                                      return Colors.blue.withOpacity(0.12);
                                    return null; // Defer to the widget's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                // TODO: Add to subscriber list / count
                              },
                              child: Text('Subscribe',
                                  style: GoogleFonts.dmSans())),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  VideoInfo.name ?? "",
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  VideoInfoBottomView
                          .PreservedVideoDataState?.video?.description ??
                      "This video has no description",
                  style: GoogleFonts.dmSans(),
                ),
              ),
            ),

            // TODO: Add comments for list video
            // getCommentsList()
          ],
        ),
      ),
    ),
  );
}

// Not used because of outdated API
Widget getCommentsList() {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: VideoInfo?.comms?.length,
    itemBuilder: (context, index) {
      return Container(
        child: Card(
          elevation: 9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: ListTile(
            dense: false,
            leading: FlutterLogo(),
            title: Text(
              VideoInfo.comms?.elementAt(index).author ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              VideoInfo.comms?.elementAt(index).text ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      );
    },
  );
}
