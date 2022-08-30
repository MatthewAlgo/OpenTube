import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../views/homepage.dart';

Future<StreamManifest> getManifest(String vidID) async {
  HomePage.loadingState = true;
  var yt = YoutubeExplode();
  var streamInfo = await yt.videos.streamsClient.getManifest('vidID');
  
  HomePage.loadingState = false;
  return streamInfo;
}

Future<VideoSearchList> getSearch(String searchquery) async {
  HomePage.loadingState = true;
  var yt = YoutubeExplode();
  var search = await yt.search.search(searchquery);

  HomePage.loadingState = false;
  return search;
}

Future<CommentsList?> getComments(Video? video) async {
  HomePage.loadingState = true;
  var yt = YoutubeExplode();
  var comments = await yt.videos.commentsClient.getComments(video!);
  
  HomePage.loadingState = false;
  return comments;
}

Future<VideoSearchList> appendToSearchList(VideoSearchList vs) async {
  HomePage.loadingState = true;
  var yt = YoutubeExplode();
  var next = await vs.nextPage();
  next = await next?.nextPage();
  if (next != null) {
    for (var video in next.sublist(0)) {
      vs.add(video);
    }
  }
 
  HomePage.loadingState = false;
  return vs;
}
