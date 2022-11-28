import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:OpenTube/video/VideoInfoBottom.dart';
import 'package:OpenTube/video/VideoView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;

class SimilarVideosView extends StatefulWidget {
  SimilarVideosView({Key? key, required List<exp.Video> this.videoRecommended})
      : super(key: key);

  List<exp.Video> videoRecommended;

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
        itemCount: widget.videoRecommended.length,
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
                  widget.videoRecommended.elementAt(index).title,
                  style: GoogleFonts.dmSans(),
                ),
                 subtitle: Column(
                   children: [
                     Text(widget.videoRecommended.elementAt(index).description,
                                  style: GoogleFonts.dmSans()),
                      Text(widget.videoRecommended.elementAt(index).author.toString() != "null" ? widget.videoRecommended.elementAt(index).author.toString() : "Unknown author",
                                  style: GoogleFonts.dmSans()),
                      Text(widget.videoRecommended.elementAt(index).uploadDate.toString() != "null" ? getVideoDate(widget.videoRecommended.elementAt(index).uploadDate.toString()) : "Unknown upload date",
                                  style: GoogleFonts.dmSans()),
                   ],
                 ),
                leading: CachedNetworkImage(
                  imageUrl: widget.videoRecommended
                      .elementAt(index)
                      .thumbnails
                      .mediumResUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                onTap: (() {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return VideoView(
                          videoId:
                              '${widget.videoRecommended.elementAt(index).id}');
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
