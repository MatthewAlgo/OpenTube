import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FetchingInitialDataView extends StatefulWidget {
  const FetchingInitialDataView({super.key});

  @override
  State<FetchingInitialDataView> createState() => FetchingInitialDataViewState();
}

class FetchingInitialDataViewState extends State<FetchingInitialDataView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Getting Channel Data", style: GoogleFonts.sacramento(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: LoadingAnimationWidget.fourRotatingDots(
                size: 50,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}