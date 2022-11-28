import 'package:flutter/material.dart';


import 'package:libretube/splash/Logo.dart';
import 'package:libretube/views/HomePage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateHome();
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    // If the user starts the app for the first time, show the onboarding screen

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Expanded(child: const FlutterScreen())],
        ),
      ),
    );
  }
}
