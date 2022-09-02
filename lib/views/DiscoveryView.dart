import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoveryView extends StatefulWidget {
  const DiscoveryView({Key? key}) : super(key: key);

  @override
  State<DiscoveryView> createState() => _DiscoveryViewState();
}

class _DiscoveryViewState extends State<DiscoveryView> {
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
      appBar: PreferredSize(
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
                    setState(() {});
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
          ))),
      backgroundColor: Colors.greenAccent,
      body: Center(
          child: Text(
        'Favorite Page',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    );
  }
}
