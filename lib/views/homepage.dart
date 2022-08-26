import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libretube/views/videoview.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utilities/youtube.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _editingcontroller;

  @override
  void initState() {
    _editingcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          body: FutureBuilder<VideoSearchList>(
            future: getSearch("Spacex Nasa"),
            builder: (BuildContext context,
                AsyncSnapshot<VideoSearchList> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return BuildCards(context, snapshot.data);
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
          appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 65),
              child: SafeArea(
                  child: Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 5))
                ]),
                alignment: Alignment.center,
                child: AnimationSearchBar(
                    isBackButtonVisible: true,
                    previousScreen: HomePage(),
                    backIconColor: Colors.black,
                    centerTitle: "LibreTube",
                    centerTitleStyle: GoogleFonts.sacramento(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                    //? Search hint text
                    hintStyle: GoogleFonts.sacramento(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                    //? Search Text
                    textStyle: GoogleFonts.sacramento(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                    onChanged: (text) => debugPrint(text),
                    searchTextEditingController: _editingcontroller,
                    horizontalPadding: 5),
              ))),
          bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.map, title: 'Discovery'),
              TabItem(icon: Icons.add, title: 'Add'),
              TabItem(icon: Icons.message, title: 'Message'),
              TabItem(icon: Icons.people, title: 'Profile'),
            ],
            initialActiveIndex: 2, //optional, default as 0
            onTap: (int i) => print('click index=$i'),
          )),
    );
  }

  Widget BuildCards(BuildContext context, VideoSearchList? list) {
    return ListView.builder(
        itemCount: list?.length,
        itemBuilder: (context, index) {
          return (index == list?.length)
              ? Container(
                  color: Colors.greenAccent,
                  child: TextButton(
                    child: const Text("Load More"),
                    onPressed: () {},
                  ),
                )
              : Card(
                  child: ListTile(
                  title: Text(list?.elementAt(index).title ?? ""),
                  subtitle: Text(list?.elementAt(index).description ?? ""),
                  leading: Container(
                    width: 100.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.white,
                    ),
                    child: Image.network(
                      list?.elementAt(index).thumbnails.standardResUrl ?? "",
                      height: 150.0,
                      width: 100.0,
                    ),
                  ),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VideoView(list?.elementAt(index).url)),
                    );
                    // Show view with the video itself
                    ;
                  },
                ));
        });
  }
}
