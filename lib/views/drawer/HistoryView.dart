import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:libretube/utilities/LocalStorageRepo.dart';
import 'package:libretube/utilities/VideoUtilH.dart';
import 'package:libretube/video/VideoView.dart';
import 'package:libretube/views/connection/EmptyPage.dart';
import 'package:libretube/views/connection/ErrorView.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytExp;

import '../HomePage.dart';
import '../connection/LoadingView.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
  static List<VideoUtilH> listHistoryViewStatic = [];
  static ValueNotifier<List<VideoUtilH>> listHistoryViewStaticNotifier =
      ValueNotifier<List<VideoUtilH>>(listHistoryViewStatic);
}

class _HistoryViewState extends State<HistoryView> {
  TextEditingController _editingcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editingcontroller.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    _editingcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: buildAppBody(),
        appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null // show nothing in lanscape mode
            : PreferredSize(
                preferredSize: const Size(double.infinity, 65),
                child: SafeArea(
                    child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      AnimSearchBar(
                        suffixIcon: Icon(Icons.send),
                        prefixIcon: Icon(Icons.search_outlined),
                        width: MediaQuery.of(context).size.width,
                        textController: _editingcontroller,
                        onSuffixTap: () {
                          Navigator.pop(context);
                          setState(() async {
                            HomePage.editingController = _editingcontroller;
                          });
                        },
                      ),
                      Expanded(
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "LibreTube",
                            maxLines: 1,
                            style: GoogleFonts.sacramento(fontSize: 30),
                            overflow: TextOverflow.fade,
                          ),
                        )),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget buildAppBody() {
    if (HistoryView.listHistoryViewStatic.length == 0) {
      return const EmptyPage();
    } else {
      return ValueListenableBuilder(
          valueListenable: HistoryView.listHistoryViewStaticNotifier,
          builder: (context, value, _) {
            return Scaffold(
              backgroundColor: Colors.lightBlue.shade100,
              body: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: HistoryView.listHistoryViewStatic.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: ListTile(
                        dense: false,
                        trailing: buildUnsaveButton(
                            HistoryView.listHistoryViewStatic.elementAt(index)),
                        title: Text(
                          HistoryView.listHistoryViewStatic
                              .elementAt(index)
                              .title,
                          style: GoogleFonts.dmSans(),
                        ),
                        leading: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: HistoryView.listHistoryViewStatic
                                .elementAt(index)
                                .thumbnailURL,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        onTap: (() async {
                          // Open The Channel Page using ytExplode
                          ytExp.YoutubeExplode ytExplode =
                              ytExp.YoutubeExplode();
                          ytExp.Video playlistVideos = await ytExplode
                              .videos
                              .get(HistoryView.listHistoryViewStatic
                                  .elementAt(index)
                                  .id);

                          // Now we build the channel page based off the provided channel
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              return VideoView(
                                videoId: HistoryView.listHistoryViewStatic
                                    .elementAt(index)
                                    .id,
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            );
          });
    }
  }

  Widget buildUnsaveButton(VideoUtilH savedVideoLocal) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered))
                return Colors.blue.withOpacity(0.04);
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.blue.withOpacity(0.12);
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirmation'),
                content: Text(
                    'Are you sure you want to remove ${savedVideoLocal.title} from history?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      VideoUtilH video = new VideoUtilH(
                        videoURL: savedVideoLocal.videoURL,
                          id: savedVideoLocal.id,
                          title: savedVideoLocal.title,
                          thumbnailURL: savedVideoLocal.thumbnailURL);

                      // Unsubscribe and refresh list
                      LocalStorageRepository localStorageRepository =
                          LocalStorageRepository();
                      Box box = await localStorageRepository.openBoxVideosHistory();
                      localStorageRepository.removeVideoHistoryFromList(
                          box, video);

                      // Assign the channel lists
                      HistoryView.listHistoryViewStatic =
                          localStorageRepository.getVideosHistoryList(box);
                      HistoryView.listHistoryViewStaticNotifier.value =
                          HistoryView.listHistoryViewStatic;
                      // Set the subscribed to channel variable equal to true

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'OK');
                      setState(() {});
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
        child: Text('Unsave', style: GoogleFonts.dmSans()));
  }
}
