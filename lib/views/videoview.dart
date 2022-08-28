import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/homepage.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late TextEditingController _seekToController;
  late TextEditingController _editingcontroller;
  YoutubePlayerController _controller = YoutubePlayerController();
  late bool autoPlay;

  @override
  void initState() {
    _editingcontroller = TextEditingController();
    autoPlay = true;
    _controller = YoutubePlayerController()
      ..onInit = () {
        if (autoPlay) {
          _controller.loadVideoById(videoId: VideoInfo.ID, startSeconds: 30);
        } else {
          _controller.cueVideoById(videoId: VideoInfo.ID, startSeconds: 30);
        }
      };
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: videoAppBody(),
          appBar: MediaQuery.of(context).orientation == Orientation.landscape
              ? null // show nothing in lanscape mode
              : PreferredSize(
                  preferredSize: const Size(double.infinity, 65),
                  child: SafeArea(
                      child: Container(
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(0, 5))
                    ]),
                    alignment: Alignment.center,
                    child: AnimationSearchBar(
                      isBackButtonVisible: true,
                      previousScreen: HomePage(),
                      backIconColor: Colors.black,
                      centerTitle: "LibreTube",
                      centerTitleStyle: GoogleFonts.sacramento(
                        textStyle: Theme.of(context).textTheme.displaySmall,
                      ),
                      //? Search hint text
                      hintStyle: GoogleFonts.sacramento(
                        textStyle: Theme.of(context).textTheme.displaySmall,
                      ),
                      //? Search Text
                      textStyle: GoogleFonts.sacramento(
                        textStyle: Theme.of(context).textTheme.displaySmall,
                      ),
                      // onChanged: (text) {
                      //   assignData(text);
                      // },
                      searchTextEditingController: _editingcontroller,
                      horizontalPadding: 5,
                      onChanged: (String) {},
                    ),
                  ))),
        ));
  }

  Widget videoAppBody() {
    return Center(
      child: YoutubePlayerScaffold(
        controller: _controller,
        aspectRatio: 16 / 9,
        builder: (context, player) {
          return Scaffold(
            body: Column(
              children: [
                player,
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      VideoInfo.name,
                      style: GoogleFonts.salsa(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      VideoInfo.description,
                      style: GoogleFonts.salsa(),
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: VideoInfo?.comms?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Card(
                        elevation: 9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: ListTile(
                          dense: false,
                          leading: FlutterLogo(),
                          title: Text(
                            VideoInfo.comms!.elementAt(index).author ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            VideoInfo.comms!.elementAt(index).text ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? null // show nothing in lanscape mode
                    : ConvexAppBar(
                        items: [
                          TabItem(icon: Icons.play_arrow, title: 'Video'),
                          TabItem(icon: Icons.message, title: 'Comments'),
                        ],
                        initialActiveIndex: 0, //optional, default as 0
                        onTap: (int i) => print('click index=$i'),
                      ),
          );
        },
      ),
    );
  }
}
