import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NoResultsView extends StatefulWidget {
  const NoResultsView({Key? key}) : super(key: key);

  @override
  State<NoResultsView> createState() => _NoResultsViewState();
}

class _NoResultsViewState extends State<NoResultsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Your search did not return any results", style: GoogleFonts.sacramento(fontSize: 30), textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: LoadingAnimationWidget.halfTriangleDot(
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
