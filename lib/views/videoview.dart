import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


class VideoView extends StatefulWidget {
  const VideoView(String? url, {Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();

  
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        ),
    );
    
  }
}