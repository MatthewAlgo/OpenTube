import 'package:hive/hive.dart';
import 'package:libretube/utilities/VideoUtilH.dart';

import 'Channel.dart';
import 'VideoUtil.dart';

abstract class BaseLocalStorageRepository {
  // For subscriptions
  Future<Box> openBox();
  List<Channel> getChannelList(Box box);
  Future<void> addChanneltoList(Box box, Channel channel);
  Future<void> removeChannelFromList(Box box, Channel channel);
  Future<void> clearChannelList(Box box);

  // For saved videos
  Future<Box> openBoxSavedVideos();
  Future<void> addSavedVideotoList(Box box, VideoUtil video);
  Future<void> clearSavedVideosList(Box box);
  List<VideoUtil> getSavedVideosList(Box box);
  Future<void> removeSavedVideoFromList(Box box, VideoUtil video);

  // For videos history
  Future<Box> openBoxVideosHistory();
  Future<void> addVideoHistorytoList(Box box, VideoUtilH video);
  Future<void> clearVideosHistoryList(Box box);
  List<VideoUtilH> getVideosHistoryList(Box box);
  Future<void> removeVideoHistoryFromList(Box box, VideoUtilH video);
}
