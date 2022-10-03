import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_store/json_store.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:libretube/utilities/Channel.dart' as chan;
import 'package:libretube/utilities/LocalStorageRepo.dart';

class SubscriptionsView extends StatefulWidget {
  SubscriptionsView({Key? key}) : super(key: key);

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
  static late List<chan.Channel> listChannelStatic;
  static late ValueNotifier<List<chan.Channel>> listChannelStaticNotifier =
      ValueNotifier<List<chan.Channel>>(listChannelStatic);
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  late var _editingcontroller;

  @override
  void initState() {
    _editingcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: SubscriptionsView.listChannelStaticNotifier,
        builder: (context, value, _) {
          return Scaffold(
            appBar: PreferredSize(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AnimSearchBar(
                        suffixIcon: Icon(Icons.send),
                        prefixIcon: Icon(Icons.search_outlined),
                        width: MediaQuery.of(context).size.width,
                        textController: _editingcontroller,
                        onSuffixTap: () {},
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
                          // Open a drawer or a view
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.menu,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                ))),
            backgroundColor: Colors.pink.shade100,
            body: Scaffold(
              body: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: SubscriptionsView.listChannelStatic.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: ListTile(
                        dense: false,
                        trailing: Icon(Icons.play_arrow_rounded),
                        title: Text(
                          SubscriptionsView.listChannelStatic
                              .elementAt(index)
                              .title,
                          style: GoogleFonts.dmSans(),
                        ),
                        leading: CachedNetworkImage(
                          imageUrl: SubscriptionsView.listChannelStatic
                              .elementAt(index)
                              .thumbnailURL,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        onTap: (() {
                          // ignore: use_build_context_synchronously
                          // Navigator.of(context, rootNavigator: true).pushReplacement(
                          //   MaterialPageRoute(builder: (context) {

                          //     return VideoView(videoId: '${VideoInfo.relatedVideos.elementAt(index).videoId}');
                          //   }),
                          // );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

class SubscriptionsList {
  static late List<chan.Channel> subscriptionsChannel;
}
