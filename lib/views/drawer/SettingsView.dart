import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:OpenTube/utilities/LocalStorageRepo.dart';
import 'package:OpenTube/views/ChannelView.dart';
import 'package:OpenTube/views/HomePage.dart';
import 'package:OpenTube/views/MainView.dart';
import 'package:OpenTube/views/SubscriptionsView.dart';
import 'package:OpenTube/views/drawer/HistoryView.dart';
import 'package:OpenTube/views/drawer/SavedVideos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static bool IS_DARK_MODE = false;
  static bool IS_HISTORY_ENABLED = true;
  static bool IS_SEARCH_BAR_ENABLED = true;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController _editingcontroller = TextEditingController();

  // Init and dispose
  @override
  void initState() {
    _editingcontroller = TextEditingController();
    super.initState();
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
                      Expanded(
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "OpenTube",
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
    return Scaffold(
      // List of toggles
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Toggle videos history'),
            trailing: Switch(
              value: SettingsView.IS_HISTORY_ENABLED,
              onChanged: (bool value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isHistoryEnabled', value);
                setState(() {
                  SettingsView.IS_HISTORY_ENABLED = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: SettingsView.IS_DARK_MODE,
              onChanged: (bool value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isDarkModeEnabled', value);
                setState(() {
                  SettingsView.IS_DARK_MODE = value;
                });
              },
            ),
          ),
          // Buttons to erase history and saved videos
          ListTile(
            title: const Text('Erase history'),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Initialize a hive box and remove all the videos
                  LocalStorageRepository localStorageRepository =
                      LocalStorageRepository();
                  Box box = await localStorageRepository.openBoxVideosHistory();

                  // Show a dialog to confirm the deletion
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm deletion'),
                          content: const Text(
                              'Are you sure you want to delete all the videos in your history?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                await box.clear();
                                // Assign the video lists
                                HistoryView.listHistoryViewStatic = [];
                                HistoryView.listHistoryViewStaticNotifier
                                    .value = HistoryView.listHistoryViewStatic;

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }),
          ),
          ListTile(
            title: const Text('Erase saved videos'),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Initialize a hive box and remove all the videos
                  LocalStorageRepository localStorageRepository =
                      LocalStorageRepository();
                  Box box = await localStorageRepository.openBoxSavedVideos();

                  // Show a dialog to confirm the deletion
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm deletion'),
                          content: const Text(
                              'Are you sure you want to delete all the saved videos?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                await box.clear();
                                // Assign the video lists
                                SavedVideos.listSavedVideosStatic = [];
                                SavedVideos.listSavedVideosStaticNotifier
                                    .value = SavedVideos.listSavedVideosStatic;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }),
          ),
          // Unsubscribe from all channels
          ListTile(
            title: const Text('Unsubscribe from all channels'),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Initialize a hive box and remove all the videos
                  LocalStorageRepository localStorageRepository =
                      LocalStorageRepository();
                  Box box = await localStorageRepository.openBox();

                  // Show a dialog to confirm the deletion
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm deletion'),
                          content: const Text(
                              'Are you sure you want to unsubscribe from all channels?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                await box.clear();
                                // Clear the list of channels
                                SubscriptionsView.listChannelStatic = [];
                                SubscriptionsView
                                        .listChannelStaticNotifier.value =
                                    SubscriptionsView.listChannelStatic;

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
