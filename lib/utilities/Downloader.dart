import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloaderForYoutube {
  Future<String> downloadYoutubeVideoFunc(
      BuildContext context, String url) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    // If the directory doesn't exist, create it
    if (!await Directory("/storage/emulated/0/Download" + '/libretube-video')
        .exists()) {
      await Directory("/storage/emulated/0/Download" + '/libretube-video')
          .create();
    }

    var yt = YoutubeExplode();
    var videoData = await yt.videos.get(url);
    var streamManifest = await yt.videos.streamsClient.getManifest(url);
    // Get highest quality muxed stream
    var streamInfo = streamManifest.muxed.bestQuality;

    if (streamInfo != null) {
      // Get the actual stream
      var stream = yt.videos.streamsClient.get(streamInfo);

      // Open a file for writing.
      var file = File(
          '/storage/emulated/0/Download/libretube-video/${videoData.title}.mp4');
      var fileStream = file.openWrite();

      // Pipe all the content of the stream into the file.
      await stream.pipe(fileStream);

      // Close the file.
      await fileStream.flush();
      await fileStream.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Downloaded ${videoData.title} at ${file.path.toString()}'),
        ),
      );
      return '/storage/emulated/0/Download/libretube-video/${videoData.title}.mp4';
    }
    return '';
  }

  // Download audio only from youtube
  Future<String> downloadYoutubeAudioFunc(
      BuildContext context, String url) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    // If the directory doesn't exist, create it
    if (!await Directory("/storage/emulated/0/Download" + '/libretube-audio')
        .exists()) {
      await Directory("/storage/emulated/0/Download" + '/libretube-audio')
          .create();
    }

    var yt = YoutubeExplode();
    var audioData = await yt.videos.get(url);
    var streamManifest = await yt.videos.streamsClient.getManifest(url);
    // Get highest quality muxed stream
    var streamInfo = streamManifest.audioOnly.withHighestBitrate();

    if (streamInfo != null) {
      // Get the actual stream
      var stream = yt.videos.streamsClient.get(streamInfo);

      // Open a file for writing.
      var file = File(
          '/storage/emulated/0/Download/libretube-audio/${audioData.title}.mp4');
      var fileStream = file.openWrite();

      // Pipe all the content of the stream into the file.
      await stream.pipe(fileStream);

      // Close the file.
      await fileStream.flush();
      await fileStream.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Downloaded ${audioData.title} at ${file.path.toString()}'),
        ),
      );
      return '/storage/emulated/0/Download/libretube-audio/${audioData.title}.mp4';
    }
    return '';
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
