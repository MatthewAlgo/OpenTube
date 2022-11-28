import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:libretube/services/NotificationManager.dart';
import 'package:libretube/splash/splash_screen.dart';
import 'package:libretube/utilities/Channel.dart';
import 'package:libretube/utilities/VideoUtil.dart';
import 'package:libretube/utilities/VideoUtilH.dart';
import 'package:libretube/views/connection/ErrorView.dart';
import 'package:libretube/views/HomePage.dart';
import 'package:libretube/video/VideoView.dart';
import 'package:libretube/views/connection/LoadingView.dart';
import 'package:libretube/views/drawer/SettingsView.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TODO: Add a splash screen

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ChannelAdapter());
  Hive.registerAdapter(VideoUtilAdapter());
  Hive.registerAdapter(VideoUtilHAdapter());

  SharedPreferences prefs = await SharedPreferences.getInstance();
  SettingsView.IS_DARK_MODE = prefs.getBool('isDarkModeEnabled') ?? false;
  SettingsView.IS_HISTORY_ENABLED = prefs.getBool('isHistoryEnabled') ?? true;

  return runApp(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => HomePage(),
        '/splash': (context) => Splash(),
      }));
}