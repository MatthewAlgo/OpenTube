// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VideoUtil.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoUtilAdapter extends TypeAdapter<VideoUtil> {
  @override
  final int typeId = 0;

  @override
  VideoUtil read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoUtil(
      id: fields[0] as String,
      title: fields[1] as String,
      thumbnailURL: fields[2] as String,
      videoURL: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoUtil obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnailURL)
      ..writeByte(3)
      ..write(obj.videoURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoUtilAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
