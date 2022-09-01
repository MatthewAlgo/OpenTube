import 'package:flutter/material.dart';
import 'package:libretube/views/homepage.dart';
import 'package:libretube/views/videoview.dart';

void main() {
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
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
