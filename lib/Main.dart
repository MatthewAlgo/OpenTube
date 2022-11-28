import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:OpenTube/services/NotificationManager.dart';
import 'package:OpenTube/splash/SplashScreen.dart';
import 'package:OpenTube/utilities/Channel.dart';
import 'package:OpenTube/utilities/VideoUtil.dart';
import 'package:OpenTube/utilities/VideoUtilH.dart';
import 'package:OpenTube/views/connection/ErrorView.dart';
import 'package:OpenTube/views/HomePage.dart';
import 'package:OpenTube/video/VideoView.dart';
import 'package:OpenTube/views/connection/LoadingView.dart';
import 'package:OpenTube/views/drawer/SettingsView.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
