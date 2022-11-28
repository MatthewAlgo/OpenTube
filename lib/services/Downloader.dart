import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'NotificationManager.dart';

class DownloaderForYoutube {
  LocalNotificationService service = LocalNotificationService();

  DownloaderForYoutube() {
    service.initialize();
  }
  Future<File> writeVideoFile(BuildContext context, String id) async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      String tempPath = "/storage/emulated/0/Download";

      // If the directory doesn't exist, create it
      if (!await Directory("${tempPath}" + '/OpenTube-video').exists()) {
        await Directory("${tempPath}" + '/OpenTube-video').create();
      }

      var yt = YoutubeExplode();
      var videoData = await yt.videos.get(id);
      // Remove all special characters from the title that are not allowed in file names
      String str2 = "|;:\"\'";
      String videoDataTrimmed = videoData.title;
      for (int i = 0; i < str2.length; i++) {
        videoDataTrimmed = videoDataTrimmed.replaceAll(str2[i], '-');
      }

      var filePath =
          tempPath + '/OpenTube-video' + '/${videoDataTrimmed}' + '.mp4';
      var streamManifest = await yt.videos.streamsClient.getManifest(id);
      // Get highest quality muxed stream
      var streamInfo = streamManifest.muxed.withHighestBitrate();

      var stream = yt.videos.streamsClient.get(streamInfo);

      // Open a file for writing.
      var file = File(filePath);
      // If the file doesn't exist, create it
      if (!await file.exists()) {
        service.showNotification(
            1, 'Video Downloading...', 'Downloading ${videoData.title}...');

        await file.create();

        var fileStream = file.openWrite();
        // showNotification("Audio ${audioData.title}", 'Downloading');

        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();
        service.showNotification(1, 'Video Downloaded',
            'Downloaded ${videoData.title} at ${filePath}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Downloaded ${videoDataTrimmed} at ${file.path.toString()}'),
          ),
        );
        return file;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Already Downloaded ${videoDataTrimmed} at ${file.path.toString()}'),
          ),
        );
        return file;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission denied'),
        ),
      );
    }
    return File('');
  }

  Future<File> writeAudioFile(BuildContext context, String id) async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      // The downloads folder path
      String tempPath = "/storage/emulated/0/Download";

      // If the directory doesn't exist, create it
      if (!await Directory("${tempPath}" + '/OpenTube-audio').exists()) {
        await Directory("${tempPath}" + '/OpenTube-audio').create();
      }

      var yt = YoutubeExplode();
      var audioData = await yt.videos.get(id);
      // Remove all special characters from the title that are not allowed in file names
      String str2 = "|;:\"\'";
      String audioDataTrimmed = audioData.title;
      for (int i = 0; i < str2.length; i++) {
        audioDataTrimmed = audioDataTrimmed.replaceAll(str2[i], '-');
      }

      var filePath =
          tempPath + '/OpenTube-audio' + '/${audioDataTrimmed}' + '.mp3';
      var streamManifest = await yt.videos.streamsClient.getManifest(id);
      // Get highest quality muxed stream
      var streamInfo = streamManifest.audioOnly.withHighestBitrate();
      var stream = yt.videos.streamsClient.get(streamInfo);

      // Open a file for writing.
      var file = File(filePath);
      // If the file doesn't exist, create it
      if (!await file.exists()) {
        service.showNotification(
            1, 'Audio Downloading...', 'Downloading ${audioData.title}...');

        await file.create();

        var fileStream = file.openWrite();
        // showNotification("Audio ${audioData.title}", 'Downloading');

        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();
        service.showNotification(1, 'Audio Downloaded',
            'Downloaded ${audioData.title} at ${filePath}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Downloaded ${audioDataTrimmed} at ${file.path.toString()}'),
          ),
        );
        return file;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Already Downloaded ${audioDataTrimmed} at ${file.path.toString()}'),
          ),
        );
        return file;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission denied'),
        ),
      );
    }
    return File('');
  }
}
