import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/utilities/YouTube.dart';
import 'package:libretube/views/connection/ErrorView.dart';
import 'package:libretube/views/connection/LoadingView.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytExp;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../video/VideoView.dart';
import 'HomePage.dart';
import 'MainView.dart';

class ChannelView extends StatefulWidget {
  const ChannelView({super.key, required ytExp.Channel this.localChannel});

  final ytExp.Channel localChannel;

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTopAppBar(),
      backgroundColor: Colors.pink.shade100,
      body: FutureBuilder<ChannelUploadsList>(
        future: loadVideosFromChannel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          } else if (snapshot.hasError) {
            return const ErrorView();
          } else if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.localChannel.bannerUrl,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white),
                      child: Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 5.0, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.localChannel.logoUrl),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(widget.localChannel.title,
                                  style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${widget.localChannel.subscribersCount} Subscribers',
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
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered))
                                          return Colors.blue.withOpacity(0.04);
                                        if (states.contains(
                                                MaterialState.focused) ||
                                            states.contains(
                                                MaterialState.pressed))
                                          return Colors.blue.withOpacity(0.12);
                                        return null; // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Get channel data from Youtube API
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
                ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      print("Reached widget building ${snapshot.data!.length}");
                      if (snapshot.data != null) {
                        if (index < snapshot.data!.length) {
                          return Card(
                              child: ListTile(
                                  title: Text(
                                      snapshot.data!
                                          .elementAt(index)
                                          .title
                                          .toString(),
                                      style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.bold)),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      color: Colors.white,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!
                                          .elementAt(index)
                                          .thumbnails
                                          .mediumResUrl,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
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
                                  onTap: () {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(builder: (context) {
                                        return VideoView(
                                            videoId:
                                                '${snapshot.data!.elementAt(index).id}');
                                      }),
                                    );
                                  }));
                        } else {
                          // Load more items -> automatically handled by listener if it exists
                        }
                      }
                      return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()));
                    }),
                Container(
                  alignment: Alignment.center,
                  child: Center(
                      child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const SizedBox(height: 30),
                      ],
                    ),
                  )),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.pink.shade100,
                      border: Border.all(width: 5.0, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFF0D47A1),
                                              Color(0xFF1976D2),
                                              Color(0xFF42A5F5),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () => _fetchNewData(snapshot
                                          .data!), // Currently not working (assertion on invalid null)
                                      child: const Text('Load More'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const ErrorView(); // Something unhandled and bad happened
          }
        },
      ),
    );
  }

  Future<ChannelUploadsList> loadVideosFromChannel() async {
    YoutubeExplode ytExplode = YoutubeExplode();
    print("Reached API call for channels");
    ChannelUploadsList videos =
        await ytExplode.channels.getUploadsFromPage(widget.localChannel.id);
    print("Videos length: ${videos.length}");
    return videos;
  }

  Future _fetchNewData(ChannelUploadsList listVideos) async {
    MainView.loadingState = true;
    listVideos = await appendToChannelList(listVideos);
    MainView.loadingState = false;
    // Update the ui without rebuilding the whole widget
    setState(() {
      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Loaded ${listVideos.length} videos'),
        ),
      );
    });
  }

  PreferredSizeWidget buildTopAppBar() {
    return PreferredSize(
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
                textController: _textEditingController,
                onSuffixTap: () {
                  Navigator.pop(context);
                  setState(() async {
                    HomePage.editingController = _textEditingController;
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
        )));
  }
}
