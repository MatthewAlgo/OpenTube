import 'package:json_store/json_store.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'VideoUtilH.g.dart';

@HiveType(typeId: 2)
class VideoUtilH {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String thumbnailURL;
  @HiveField(3)
  final String videoURL;

  VideoUtilH(
      {required this.id,
      required this.title,
      required this.thumbnailURL,
      required this.videoURL});

  factory VideoUtilH.fromJson(Map<String, dynamic> json) => VideoUtilH(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailURL: json['channelURL'],
      videoURL: json['thumbnailURL']);

  Map<String, dynamic> toJson() => _$VideoUtilToJson(this);

  VideoUtilH _$VideoUtilFromJson(Map<String, dynamic> json) => VideoUtilH(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailURL: json['channelURL'],
      videoURL: json['thumbnailURL']);

  Map<String, dynamic> _$VideoUtilToJson(VideoUtilH instance) => <String, dynamic>{
        'id': instance.id,
        'title': instance.title,
        'channelURL': instance.thumbnailURL,
        'thumbnailURL': instance.videoURL
      };
}
