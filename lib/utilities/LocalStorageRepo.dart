import 'package:hive/hive.dart';
import 'package:libretube/utilities/BaseLocalStorageRepo.dart';
import 'package:libretube/utilities/Channel.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  String boxName = 'channel_subscriptions';

  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox<Channel>(boxName);
    return box;
  }

  @override
  Future<void> addChanneltoList(Box box, Channel channel) async{
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
  Future<void> removeChannelFromList(Box box, Channel channel) async{
    await box.delete(channel.id);
  }
}
