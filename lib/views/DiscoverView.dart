import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/video/VideoView.dart';
// Import youtube explode
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  static late List<exp.Video> videoListDiscover;

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

// Create an enum for World News, Weather, Sports, Entertainment, and Technology and Politics
enum DiscoverType { News, Weather, Entertainment,Sports, Technology, Politics, Music }

class _DiscoverViewState extends State<DiscoverView> {

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
      body: BuildCards(context, DiscoverView.videoListDiscover),
    );
  }

  Future<List<exp.Video>> _refreshPage() async {
    setState(() {
      DiscoverView.videoListDiscover.length;
    });
    return DiscoverView.videoListDiscover;
  }

  Widget BuildCards(BuildContext context, List<exp.Video>? list) {
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
                return Column(
                  children: [
                    // Create a field of the value of the enum if the index is a multiple of 20
                    if (index % 20 == 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DiscoverType.values[index ~/ 20].toString().split('.').last,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Card(
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
                                    .thumbnails.lowResUrl,
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
                                  return VideoView(videoId: '${list.elementAt(index).id}');
                                }),
                              );
                            })),
                  ],
                );
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
