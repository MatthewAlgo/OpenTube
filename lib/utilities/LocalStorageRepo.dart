import 'package:hive/hive.dart';
import 'package:libretube/utilities/BaseLocalStorageRepo.dart';
import 'package:libretube/utilities/Channel.dart';
import 'package:libretube/utilities/VideoUtil.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  String boxName = 'channel_subscriptions';
  String savedVideosBoxName = 'saved_videos';
  String videosHistoryBoxName = 'video_history';

  // For channel subscriptions
  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox<Channel>(boxName);
    return box;
  }

  @override
  Future<void> addChanneltoList(Box box, Channel channel) async {
    await box.put(channel.id, channel);
  }

  @override
  Future<void> clearChannelList(Box box) async {
    await box.clear();
  }

  @override
  List<Channel> getChannelList(Box box) {
    return box.values.toList() as List<Channel>;
  }

  @override
  Future<void> removeChannelFromList(Box box, Channel channel) async {
    await box.delete(channel.id);
  }

  // For saved videos
  @override
  Future<Box> openBoxSavedVideos() async {
    Box box = await Hive.openBox<VideoUtil>(savedVideosBoxName);
    return box;
  }

  @override
  Future<void> addSavedVideotoList(Box box, VideoUtil video) async {
    await box.put(video.id, video);
  }

  @override
  Future<void> clearSavedVideosList(Box box) async {
    await box.clear();
  }

  @override
  List<VideoUtil> getSavedVideosList(Box box) {
    return box.values.toList() as List<VideoUtil>;
  }

  @override
  Future<void> removeSavedVideoFromList(Box box, VideoUtil video) async {
    await box.delete(video.id);
  }


  // For videos history
  @override
  Future<Box> openBoxVideosHistory() async {
    Box box = await Hive.openBox<VideoUtil>(videosHistoryBoxName);
    return box;
  }

  @override
  Future<void> addVideoHistorytoList(Box box, VideoUtil video) async {
    await box.put(video.id, video);
  }

  @override
  Future<void> clearVideosHistoryList(Box box) async {
    await box.clear();
  }

  @override
  List<VideoUtil> getVideosHistoryList(Box box) {
    return box.values.toList() as List<VideoUtil>;
  }

  @override
  Future<void> removeVideoHistoryFromList(Box box, VideoUtil video) async {
    await box.delete(video.id);
  }

}
