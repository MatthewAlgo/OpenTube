import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/HomePage.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController _editingcontroller = TextEditingController();

  // Init and dispose
  @override
  void initState() {
    _editingcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _editingcontroller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: buildAppBody(),
        appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null // show nothing in lanscape mode
            : PreferredSize(
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
                    children: <Widget>[
                      AnimSearchBar(
                        suffixIcon: Icon(Icons.send),
                        prefixIcon: Icon(Icons.search_outlined),
                        width: MediaQuery.of(context).size.width,
                        textController: _editingcontroller,
                        onSuffixTap: () {
                          Navigator.pop(context);
                          setState(() async {
                            HomePage.editingController = _editingcontroller;
                          });
                        },
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
                          Navigator.pop(context);
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}

Widget buildAppBody() {
  return Scaffold();
}
