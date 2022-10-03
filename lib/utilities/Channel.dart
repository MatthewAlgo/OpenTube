import 'package:json_serializable/builder.dart';
import 'package:json_store/json_store.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'Channel.g.dart';

@HiveType(typeId: 0)
class Channel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String channelURL;
  @HiveField(3)
  final String thumbnailURL;

  Channel(
      {required this.id,
      required this.title,
      required this.channelURL,
      required this.thumbnailURL});

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as String,
      title: json['title'] as String,
      channelURL: json['channelURL'],
      thumbnailURL: json['thumbnailURL']);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as String,
      title: json['title'] as String,
      channelURL: json['channelURL'],
      thumbnailURL: json['thumbnailURL']);

  Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
        'id': instance.id,
        'title': instance.title,
        'channelURL': instance.channelURL,
        'thumbnailURL': instance.thumbnailURL
      };
}
