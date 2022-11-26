import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
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

/// TODO: Repair search bar weird behavior
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

  runApp(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      }));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}
