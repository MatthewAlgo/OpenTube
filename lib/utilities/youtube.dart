import 'package:flutter/material.dart';
import 'package:libretube/video/VideoView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;

import '../views/HomePage.dart';

Future<exp.StreamManifest> getManifest(String vidID) async {
  HomePage.loadingState = true;
  var yt = exp.YoutubeExplode();
  var streamInfo = await yt.videos.streamsClient.getManifest('vidID');

  HomePage.loadingState = false;
  return streamInfo;
}

Future<exp.VideoSearchList> getSearch(
    String searchquery, BuildContext context) async {
  HomePage.loadingState = true;
  var yt = exp.YoutubeExplode();
  late exp.VideoSearchList search;
  try {
    search = await yt.search.search(searchquery);
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: ${e.toString()}")));
  }
  HomePage.loadingState = false;
  return search;
}

Future<exp.CommentsList?> getComments(exp.Video video) async {
  HomePage.loadingState = true;
  var yt = exp.YoutubeExplode();
  var comments = await yt.videos.commentsClient.getComments(video);
  HomePage.loadingState = false;
  return comments;
}

Future<exp.VideoSearchList> appendToSearchList(exp.VideoSearchList vs) async {
  HomePage.loadingState = true;
  var yt = exp.YoutubeExplode();
  var next = await vs.nextPage();
  if (next != null) {
    for (var video in next.sublist(0)) {
      vs.add(video);
    }
  }

  HomePage.loadingState = false;
  return vs;
}

