import 'package:flutter/material.dart';
import 'package:OpenTube/video/VideoView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exp;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../views/HomePage.dart';

Future<exp.StreamManifest> getManifest(String vidID) async {
  HomePage.loadingState = true;
  YoutubeExplode ytExplode = exp.YoutubeExplode();
  StreamManifest streamInfo =
      await ytExplode.videos.streamsClient.getManifest('vidID');

  HomePage.loadingState = false;
  return streamInfo;
}

Future<exp.VideoSearchList> getSearch(
    String searchquery, BuildContext context) async {
  HomePage.loadingState = true;
  var ytExplode = exp.YoutubeExplode();
  late exp.VideoSearchList search;
  try {
    search = await ytExplode.search.search(searchquery);
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: ${e.toString()}")));
  }
  HomePage.loadingState = false;
  return search;
}

Future<exp.CommentsList?> getComments(exp.Video video) async {
  HomePage.loadingState = true;
  YoutubeExplode ytExplode = exp.YoutubeExplode();
  CommentsList? comments =
      await ytExplode.videos.commentsClient.getComments(video);
  HomePage.loadingState = false;
  return comments;
}

Future<exp.VideoSearchList> appendToSearchList(
    exp.VideoSearchList videoSearchLocal, BuildContext context) async {
  HomePage.loadingState = true;
  var ytExplode = exp.YoutubeExplode();
  var next = await videoSearchLocal.nextPage();
  if (next != null && next.isNotEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Loading...")));
    for (var video in next.sublist(0)) {
      videoSearchLocal.add(video);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No more videos to load / End of search list")));
  }

  HomePage.loadingState = false;
  return videoSearchLocal;
}

Future<ChannelUploadsList> appendToChannelList(
    ChannelUploadsList uploadsList) async {
  HomePage.loadingState = true;
  exp.YoutubeExplode ytExplode = exp.YoutubeExplode();
  List<exp.Video> nextPage = (await uploadsList.nextPage())!.toList();
  if (nextPage != null && nextPage != uploadsList) {
    for (var video in nextPage.sublist(0)) {
      uploadsList.add(video);
    }
  }

  // HomePage.loadingState = false;
  return uploadsList;
}
