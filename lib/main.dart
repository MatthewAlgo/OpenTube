import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:libretube/utilities/NotificationService.dart';
import 'package:libretube/views/HomePage.dart';
import 'package:libretube/video/VideoView.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/video/': (context) => VideoView(),
      }));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NotificationService notificationService;
  
  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  // void listenToNotificationStream() =>
  //     notificationService.behaviorSubject.listen((payload) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => MySecondScreen(payload: payload)));
  //     });

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
      });

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
