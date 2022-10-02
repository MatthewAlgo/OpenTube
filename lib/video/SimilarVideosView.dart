import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/video/VideoInfoBottom.dart';
import 'package:libretube/video/VideoView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SimilarVideosView extends StatefulWidget {
  const SimilarVideosView({Key? key}) : super(key: key);

  @override
  State<SimilarVideosView> createState() => _SimilarVideosViewState();
}

class _SimilarVideosViewState extends State<SimilarVideosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: VideoInfo.relatedVideos?.length,
        itemBuilder: (context, index) {
          return Container(
            child: Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: ListTile(
                dense: false,
                trailing: Icon(Icons.play_arrow_rounded),
                title: Text(
                  VideoInfo.relatedVideos?.elementAt(index)!.title ?? "",
                  style: GoogleFonts.dmSans(),
                ),
                leading: CachedNetworkImage(
                  imageUrl: VideoInfo.relatedVideos
                          .elementAt(index)
                          .thumbnails
                          ?.elementAt(0)
                          .url ??
                      "",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                onTap: (()  {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) {

                      return VideoView(videoId: '${VideoInfo.relatedVideos.elementAt(index).videoId}');
                    }),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
