import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloaderForYoutube {
  Future<String> downloadYoutubeVideoFunc(
      BuildContext context, String url) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    // If the directory doesn't exist, create it
    if (!await Directory(appDocDirectory.path + '/videos').exists()) {
      await Directory(appDocDirectory.path + '/videos').create();
    }

    var yt = YoutubeExplode();
    var video = await yt.videos.get(url);
    var manifest = await yt.videos.streamsClient.getManifest(url);
    var streamInfo = manifest.muxed.first;
    var stream = yt.videos.streamsClient.get(streamInfo);
    var file = File('${appDocDirectory.path}/videos/${video.title}.mp4');
    await file.writeAsBytes(await stream.toBytes());
    // Show a snackbar, according to the platform.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloaded ${video.title} at ${file.path.toString()}'),
      ),
    );
    return file.path;
  }
}
