import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'VideoInfoBottom.dart';
import 'VideoView.dart';

class VideoCommentsView extends StatefulWidget {
  const VideoCommentsView({super.key});

  @override
  State<VideoCommentsView> createState() => _VideoCommentsViewState();
}

class _VideoCommentsViewState extends State<VideoCommentsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: VideoInfo.comments.length,
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
                  VideoInfo.comments.elementAt(index).author,
                  style: GoogleFonts.dmSans(),
                ),
                subtitle: Text(
                  VideoInfo.comments.elementAt(index).text,
                  style: GoogleFonts.dmSans(),
                ),
                onTap: (() async {}),
              ),
            ),
          );
        },
      ),
    );
  }
}
