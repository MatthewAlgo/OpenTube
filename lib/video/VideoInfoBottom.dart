import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:OpenTube/data/Pair.dart';
import 'package:OpenTube/services/Downloader.dart';
import 'package:OpenTube/services/NotificationManager.dart';
import 'package:OpenTube/utilities/LocalStorageRepo.dart';
import 'package:OpenTube/utilities/VideoUtil.dart';
import 'package:OpenTube/views/connection/ErrorView.dart';
import 'package:OpenTube/views/connection/LoadingView.dart';
import 'package:OpenTube/views/drawer/SavedVideos.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_data_api/models/video_data.dart';
import 'package:youtube_data_api/youtube_data_api.dart' as data;

// import video from youtube data api
import 'package:youtube_data_api/models/video.dart' as viddata;

import 'package:youtube_explode_dart/youtube_explode_dart.dart' as explode;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utilities/YouTube.dart';
import '../views/ChannelView.dart';
import '../views/SubscriptionsView.dart';
import 'VideoView.dart';
import '../utilities/Channel.dart' as chan;

class VideoInfoBottomView extends StatefulWidget {
  VideoInfoBottomView({
    Key? key,
    required String this.vidIdent,
    required this.videodata,
  }) : super(key: key);

  static int numberOfCallsFromTabChange = 0;
  static Pair<explode.Video, explode.Channel>? savedSnapshot;

  final String vidIdent;
  final Pair<explode.Video, explode.Channel> videodata;

  @override
  State<VideoInfoBottomView> createState() => _VideoInfoBottomViewState();
}

class _VideoInfoBottomViewState extends State<VideoInfoBottomView>
    with AutomaticKeepAliveClientMixin {
  List<viddata.Video> relatedVideos = [];
  // late final LocalNotificationService service;
  // LocalNotificationService service = LocalNotificationService();

  @override
  void initState() {
    // service = LocalNotificationService();
    // service.initialize();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    VideoInfoBottomView.numberOfCallsFromTabChange++;

    // If the orientation is land
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      VideoView.selectedpage = 0;
    }

    if (VideoInfoBottomView.numberOfCallsFromTabChange != 1) {
      return getPageBody(context, VideoInfoBottomView.savedSnapshot!);
    } else {
      VideoInfoBottomView.savedSnapshot = widget.videodata;
      return getPageBody(context, widget.videodata);
    }
  }

  Widget getPageBody(
      BuildContext context, Pair<explode.Video, explode.Channel> snapshot) {
    explode.Video videofromsnapshot = snapshot.getFirst();
    // Initalize a searchVideo object using the videofromsnapshot

    // Get the explode.Channel channel of the video
    explode.Channel channelsnap = snapshot.getSecond();

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
                            child: Icon(Icons.play_circle),
                          ), // <-- Icon
                          Text(videofromsnapshot.isLive ? "Live" : "Not Live",
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
                              getVideoDate(
                                  videofromsnapshot.publishDate.toString()),
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
                          "https://www.youtube.com/watch?v=${videofromsnapshot.id}",
                          subject:
                              "https://www.youtube.com/watch?v=${videofromsnapshot.id}",
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
                                style: GoogleFonts.dmSans(
                                    fontSize: 12)), // <-- Text
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
                          onPressed: () async {
                            DownloaderForYoutube downloaderForYoutube =
                                DownloaderForYoutube();
                            await downloaderForYoutube.writeVideoFile(
                                context, videofromsnapshot.id.toString());
                          },
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
                          onPressed: () async {
                            // Add video to the saved videos list hive box
                            // Get channel data from Youtube API

                            VideoUtil video = new VideoUtil(
                              videoURL:
                                  'https://www.youtube.com/watch?v=${videofromsnapshot.id.toString()}',
                              title: videofromsnapshot.title,
                              thumbnailURL:
                                  videofromsnapshot.thumbnails.highResUrl,
                              id: videofromsnapshot.id.toString(),
                            );

                            LocalStorageRepository localStorageRepository =
                                LocalStorageRepository();
                            Box box = await localStorageRepository
                                .openBoxSavedVideos();

                            print("List for saved videos: ${box.values}");

                            if (!box
                                .containsKey(videofromsnapshot.id.toString())) {
                              localStorageRepository.addSavedVideotoList(
                                  box, video);

                              print("Video added to the saved videos list");

                              // Assign the video lists
                              SavedVideos.listSavedVideosStatic =
                                  localStorageRepository
                                      .getSavedVideosList(box);
                              SavedVideos.listSavedVideosStaticNotifier.value =
                                  SavedVideos.listSavedVideosStatic;

                              print("Value assigned to the saved videos list");

                              // Subscribed to channel is true
                              // Show the snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Video ${video.title} saved to your list"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              // Already subscribed to channel
                              // Remove from the list
                              localStorageRepository.removeSavedVideoFromList(
                                  box, video);
                              // Show the snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Video ${video.title} removed from your list"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
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
                          // Start downloading youtube video from server
                          onPressed: () async {
                            DownloaderForYoutube downloaderForYoutube =
                                DownloaderForYoutube();
                            // await service.showNotification(1, 'Downloading...', "Now downloading");
                            await downloaderForYoutube.writeAudioFile(
                                context, videofromsnapshot.id.toString());
                            // await service.showNotification(2, 'Downloaded', "Downloaded");
                          },
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
                      GestureDetector(
                        onTap: (() async {
                          // Open The Channel Page using ytExplode
                          explode.YoutubeExplode ytExplode =
                              explode.YoutubeExplode();
                          explode.Channel playlistVideos = await ytExplode
                              .channels
                              .get(videofromsnapshot.channelId);

                          // Now we build the channel page based off the provided channel
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return ChannelView(
                                localChannel: playlistVideos,
                              );
                            }),
                          );
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(channelsnap.logoUrl.toString()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(channelsnap.title.toString(),
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${channelsnap.subscribersCount.toString() != "null" ? channelsnap.subscribersCount.toString() : "No"} Subscribers',
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
                                      if (states
                                          .contains(MaterialState.hovered))
                                        return Colors.blue.withOpacity(0.04);
                                      if (states.contains(
                                              MaterialState.focused) ||
                                          states
                                              .contains(MaterialState.pressed))
                                        return Colors.blue.withOpacity(0.12);
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () async {
                                  // Get channel data from Youtube API

                                  chan.Channel channel = chan.Channel(
                                    id: videofromsnapshot.channelId.toString(),
                                    title: videofromsnapshot.author.toString(),
                                    thumbnailURL:
                                        channelsnap.logoUrl.toString(),
                                    channelURL:
                                        'https://www.youtube.com/channel/${channelsnap.id}',
                                  );

                                  LocalStorageRepository
                                      localStorageRepository =
                                      LocalStorageRepository();
                                  Box box =
                                      await localStorageRepository.openBox();

                                  if (!box.containsKey(channel.id)) {
                                    localStorageRepository.addChanneltoList(
                                        box, channel);

                                    // Assign the channel lists
                                    SubscriptionsView.listChannelStatic =
                                        localStorageRepository
                                            .getChannelList(box);
                                    SubscriptionsView
                                            .listChannelStaticNotifier.value =
                                        SubscriptionsView.listChannelStatic;
                                    // Subscribed to channel is true
                                    // Show the snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Subscribed to ${channel.title}"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    // Already subscribed to channel
                                    localStorageRepository
                                        .removeChannelFromList(box, channel);
                                    // Show the snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Unsubscribed from ${channel.title}"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
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
                    videofromsnapshot.title.toString() != ""
                        ? videofromsnapshot.title.toString()
                        : 'This video has no title',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    videofromsnapshot.description.toString() == ''
                        ? 'This video has no description'
                        : videofromsnapshot.description.toString(),
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

  String getVideoDate(String originalDate) {
    // Get the first part of the date before space
    String date = originalDate.split(' ')[0];
    // Split the date into day, month and year
    List<String> dateSplit = date.split('-');
    // Get the month
    String month = dateSplit[1];
    // Get the day
    String day = dateSplit[2];
    // Get the year
    String year = dateSplit[0];
    // Return the date in the format of day month year
    return '$year-$month-$day';
  }
}
