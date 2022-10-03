

import 'package:hive/hive.dart';

import 'Channel.dart';

abstract class BaseLocalStorageRepository {
  Future<Box> openBox();
  List<Channel> getChannelList(Box box);
  Future<void> addChanneltoList(Box box, Channel channel);
  Future<void> removeChannelFromList(Box box, Channel channel);
  Future<void> clearChannelList(Box box);
}
