import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:OpenTube/video/VideoInfoBottom.dart';
import 'package:youtube_data_api/models/video.dart' as vid;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../video/VideoView.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({Key? key}) : super(key: key);
  static late List<vid.Video> videoListTrending;

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
      backgroundColor: Colors.lightBlue.shade100,
      body: BuildCards(context, TrendingView.videoListTrending),
    );
  }

  Future<List<vid.Video>> _refreshPage() async {
    setState(() {
      TrendingView.videoListTrending.length;
    });
    return TrendingView.videoListTrending;
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
                        subtitle: Column(
                          children: [
                            Text(
                                list.elementAt(index).channelName.toString(),
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                            ),
                            Text(list.elementAt(index).views.toString(),
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                            ),
                            Text(list.elementAt(index).duration.toString(),
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
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
                        onTap: () {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              return VideoView(
                                  videoId: '${list.elementAt(index).videoId}');
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
