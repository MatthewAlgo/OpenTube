import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class channelStructure {
  final String channelID;
  final String thumbURL;
  final String subscriberCount;
  final String backgroundImageURL;
  channelStructure(
      {required this.channelID,
      required this.thumbURL,
      required this.subscriberCount,
      required this.backgroundImageURL});
  factory channelStructure.fromJson(Map<String, dynamic> json) =>
      _$channelStructureFromJson(json);

  /// Connect the generated [_$channelStructureFromJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$channelStructureFromJsonInstance(this);
}


channelStructure _$channelStructureFromJson(Map<String, dynamic> json) =>
    channelStructure(
      channelID: json['channelID'] as String,
      thumbURL: json['thumbURL'] as String,
      subscriberCount: json['subscriberCount'] as String,
      backgroundImageURL: json['backgroundImageURL'] as String,
    );

Map<String, dynamic> _$channelStructureFromJsonInstance(channelStructure instance) =>
    <String, dynamic>{
      'channelID': instance.channelID,
      'thumbURL': instance.thumbURL,
      'subscriberCount': instance.subscriberCount,
      'backgroundImageURL': instance.backgroundImageURL,
    };
