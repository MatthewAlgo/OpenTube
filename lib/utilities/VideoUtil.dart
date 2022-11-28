import 'package:json_store/json_store.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'VideoUtil.g.dart';

@HiveType(typeId: 1)
class VideoUtil {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String thumbnailURL;
  @HiveField(3)
  final String videoURL;

  VideoUtil(
      {required this.id,
      required this.title,
      required this.thumbnailURL,
      required this.videoURL});

  factory VideoUtil.fromJson(Map<String, dynamic> json) => VideoUtil(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailURL: json['channelURL'],
      videoURL: json['thumbnailURL']);

  Map<String, dynamic> toJson() => _$VideoUtilToJson(this);

  VideoUtil _$VideoUtilFromJson(Map<String, dynamic> json) => VideoUtil(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailURL: json['channelURL'],
      videoURL: json['thumbnailURL']);

  Map<String, dynamic> _$VideoUtilToJson(VideoUtil instance) => <String, dynamic>{
        'id': instance.id,
        'title': instance.title,
        'channelURL': instance.thumbnailURL,
        'thumbnailURL': instance.videoURL
      };
}
