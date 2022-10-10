import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key});

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  late var _editingcontroller;

  @override
  void initState() {
    _editingcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHigherSearchBar(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Nothing Here For Now", style: GoogleFonts.sacramento(fontSize: 30), textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: LoadingAnimationWidget.newtonCradle(
                size: 50,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget buildHigherSearchBar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: SafeArea(
            child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(0, 5))
              ],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimSearchBar(
                suffixIcon: Icon(Icons.send),
                prefixIcon: Icon(Icons.search_outlined),
                width: MediaQuery.of(context).size.width,
                textController: _editingcontroller,
                onSuffixTap: () {},
              ),
              Expanded(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "LibreTube",
                    maxLines: 1,
                    style: GoogleFonts.sacramento(fontSize: 30),
                    overflow: TextOverflow.fade,
                  ),
                )),
              ),
              RawMaterialButton(
                onPressed: () {
                  // Open a drawer or a view
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.menu,
                  size: 35.0,
                ),
                shape: CircleBorder(),
              ),
            ],
          ),
        )));
  }
}
