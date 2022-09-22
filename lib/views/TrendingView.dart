import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/video/VideoInfoBottom.dart';
import 'package:youtube_data_api/models/video.dart' as vid;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../video/VideoView.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({Key? key}) : super(key: key);
  static late List<vid.Video> videoListDiscovery;

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  late var _editingcontroller;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    _editingcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
                    setState(() {});
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
                    // Open a drawer or a view
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ))),
      backgroundColor: Colors.greenAccent,
      body: BuildCards(context, TrendingView.videoListDiscovery),
    );
  }

  Future<List<vid.Video>> _refreshPage() async {
    setState(() {
      TrendingView.videoListDiscovery.length;
    });
    return TrendingView.videoListDiscovery;
  }

  Widget BuildCards(BuildContext context, List<vid.Video>? list) {
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
                        title: Text(list.elementAt(index).title.toString(),
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold)),
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: list
                                .elementAt(index)
                                .thumbnails![0]
                                .url
                                .toString(),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
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
                        onTap: () async {
                          // Pass the video through the explode functions
                          YoutubeExplode yt = YoutubeExplode();
                          var video = await yt.videos.get(
                              'https://youtube.com/watch?v=${list.elementAt(index).videoId}');
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              // Populate static video info to be passed further
                              VideoInfo.video = video;
                              // Other elements to be easier to access
                              VideoInfo.ID = video.id.toString() ?? "";
                              VideoInfo.author = video.author ?? "";
                              VideoInfo.description =
                                  video.description.characters.string ?? "";
                              VideoInfo.name = video.title ?? "";
                              VideoInfo.publishDate = video.publishDate;
                              VideoInfo.channelID = video.channelId;
                              VideoInfo.isLive = video.isLive;
                              VideoInfo.keywords = video.keywords;

                              VideoInfoBottomView.NumberOfCallsFromTabChange =0;
                                  
                              return const VideoView();
                            }),
                          );
                        }));
              } else {
                // Load more items
              }
            }
            return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()));
          }),
    );
  }
}
