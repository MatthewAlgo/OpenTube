import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/drawer/HistoryView.dart';
import 'package:libretube/views/drawer/SavedVideos.dart';
import 'package:libretube/views/drawer/SettingsView.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.lightBlue.shade100,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlue,
              ),
              child: Text(
                'LibreTube',
                style: GoogleFonts.adventPro(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryView()),
                );
              },
              leading: Icon(Icons.fast_rewind_rounded),
              title: Text('Video History'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedVideos()),
                );
              },
              leading: Icon(Icons.bookmark_rounded),
              title: Text('Saved Videos'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsView()),
                );
              },
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
