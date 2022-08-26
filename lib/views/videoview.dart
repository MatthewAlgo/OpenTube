import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  const VideoView(String? url, {Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();

  static final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
    ),
  );
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YoutubePlayer(
    controller: VideoView._controller,
    showVideoProgressIndicator: true,
    // videoProgressIndicatorColor: Colors.amber,
    // progressColors: ProgressColors(
    //     playedColor: Colors.amber,
    //     handleColor: Colors.amberAccent,
    // ),
    onReady: () {
        // VideoView._controller.addListener(listener);
    },
),
)
    );
    
  }
}