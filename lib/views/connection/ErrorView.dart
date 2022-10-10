import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Error. Try again later", style: GoogleFonts.sacramento(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: LoadingAnimationWidget.fallingDot(
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
