import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import youtube explode dart
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;

class CommentsView extends StatefulWidget {
  const CommentsView({super.key, required this.commentsList});

  final exp.CommentsList commentsList;

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  @override
  Widget build(BuildContext context) {
    // Return a list view builder containing the comments;
    // If the length of the comments list is 0, return a text widget saying "No comments"
    return widget.commentsList.length == 0
        ? // Render visually appealing text widget
        Center(
            child: Text(
              'This video has no comments',
              style: GoogleFonts.sacramento(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
      itemCount: widget.commentsList.length,
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            elevation: 9,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: ListTile(
              dense: false,
              leading: Icon(Icons.person_rounded),
              title: Text(
                widget.commentsList.elementAt(index).author,
                style: GoogleFonts.dmSans(),
              ),
              subtitle: Text(
                widget.commentsList.elementAt(index).text,
                style: GoogleFonts.dmSans(),
              ),

              // Add icons for like and dislike in the right side of the comment
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Icon(Icons.thumb_up),
                      Text(
                        widget.commentsList.elementAt(index).likeCount.toString(),
                        style: GoogleFonts.dmSans(),
                      ),
                    ],
                  ),
                  // Add a space between the like and dislike icons
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Icon(Icons.heart_broken_rounded),
                      Text(
                        widget.commentsList.elementAt(index).isHearted ? "Loved" : "",
                        style: GoogleFonts.dmSans(),
                      ),
                    ],
                  ),
                ],
              ),

              onTap: (() {
                // TODO: Go to the commenter's channel
              }),
            ),
          ),
        );
      },
    );
  }
}