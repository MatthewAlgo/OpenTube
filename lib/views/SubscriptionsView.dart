import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:json_store/json_store.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:libretube/utilities/Channel.dart' as chan;
import 'package:libretube/utilities/LocalStorageRepo.dart';
import 'package:libretube/views/ChannelView.dart';
import 'package:libretube/views/connection/EmptyPage.dart';
import 'package:youtube_data_api/models/channel.dart' as datachan;
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytExp;

import 'dart:developer' as developer;

import '../video/VideoInfoBottom.dart';
import 'HomePage.dart';

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
    if (SubscriptionsView.listChannelStatic.length == 0) {
      return const EmptyPage();
    } else {
      return ValueListenableBuilder(
          valueListenable: SubscriptionsView.listChannelStaticNotifier,
          builder: (context, value, _) {
            return Scaffold(
              backgroundColor: Colors.lightBlue.shade100,
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
                        trailing: buildUnSubscribeButton(SubscriptionsView
                            .listChannelStatic
                            .elementAt(index)),
                        title: Text(
                          SubscriptionsView.listChannelStatic
                              .elementAt(index)
                              .title,
                          style: GoogleFonts.dmSans(),
                        ),
                        leading: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
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
                        ),
                        onTap: (() async {
                          // Open The Channel Page using ytExplode
                          ytExp.YoutubeExplode ytExplode =
                              ytExp.YoutubeExplode();
                          ytExp.Channel playlistVideos = await ytExplode
                              .channels
                              .get(SubscriptionsView.listChannelStatic
                                  .elementAt(index)
                                  .id);

                          // Now we build the channel page based off the provided channel
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              return ChannelView(
                                localChannel: playlistVideos,
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

  Widget buildUnSubscribeButton(chan.Channel channelLocal) {
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
                    'Are you sure you want to unsubscribe from ${channelLocal.title}?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      chan.Channel channel = chan.Channel(
                          id: channelLocal.id,
                          title: channelLocal.title,
                          thumbnailURL: channelLocal.thumbnailURL,
                          channelURL: channelLocal.channelURL);

                      // Unsubscribe and refresh list
                      LocalStorageRepository localStorageRepository =
                          LocalStorageRepository();
                      Box box = await localStorageRepository.openBox();
                      localStorageRepository.removeChannelFromList(
                          box, channel);

                      // Assign the channel lists
                      SubscriptionsView.listChannelStatic =
                          localStorageRepository.getChannelList(box);
                      SubscriptionsView.listChannelStaticNotifier.value =
                          SubscriptionsView.listChannelStatic;
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
        child: Text('Unsubscribe', style: GoogleFonts.dmSans()));
  }
}

class SubscriptionsList {
  static late List<chan.Channel> subscriptionsChannel;
}
