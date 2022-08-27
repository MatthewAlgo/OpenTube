import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<StreamManifest> getManifest(String vidID) async {
  var yt = YoutubeExplode();
  var streamInfo = await yt.videos.streamsClient.getManifest('vidID');
  return streamInfo;
}

Future<VideoSearchList> getSearch(String searchquery) async {
  var yt = YoutubeExplode();
  var search = await yt.search.search(searchquery);
  return search;
}

