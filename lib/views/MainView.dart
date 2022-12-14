import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:OpenTube/utilities/VideoUtil.dart';
import 'package:OpenTube/utilities/VideoUtilH.dart';
import 'package:OpenTube/views/DiscoverView.dart';
import 'package:OpenTube/views/HomePage.dart';
import 'package:OpenTube/views/connection/NoResultsView.dart';
import 'package:OpenTube/views/TrendingView.dart';
import 'package:OpenTube/views/connection/ErrorView.dart';
import 'package:OpenTube/views/connection/LoadingView.dart';
import 'package:OpenTube/views/SubscriptionsView.dart';
import 'package:OpenTube/video/VideoView.dart';
import 'package:OpenTube/views/drawer/HistoryView.dart';
import 'package:OpenTube/views/drawer/SavedVideos.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_data_api/models/playlist.dart';
import 'package:youtube_data_api/models/video_data.dart';
import 'package:youtube_data_api/youtube_data_api.dart' as dataapi;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_data_api/models/video.dart' as vid;

import '../utilities/LocalStorageRepo.dart';
import '../utilities/YouTube.dart';
import '../video/VideoInfoBottom.dart';
import '../utilities/Channel.dart' as chan;

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);
  static String searchQuery = "";
  static bool loadingState = false; // Acts like a pseudo-mutex
  static int init_counter_from_rebuild = 0;
  static List<Video> VideosSearchedList = [];

  static int isLoadingState = 0;

  static ValueNotifier<bool> wannaRebuild = ValueNotifier(false);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with AutomaticKeepAliveClientMixin<MainView> {
  late VideoSearchList VideosSearched;

  final ScrollController controller = ScrollController();
  static bool comingFromFetch = false;

  @override
  void initState() {
    super.initState();
    var focusNode = FocusNode();
    controller.addListener(() async {
      if (controller.position.atEdge &&
          !(controller.position.pixels == 0)) {
        await _fetchNewData();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.lightBlue.shade100,
        resizeToAvoidBottomInset: false,
        body: ValueListenableBuilder<bool>(
          builder: (BuildContext context, bool value, Widget? child) {
            return returnFutureBuilder();
          },
          valueListenable: MainView.wannaRebuild,
        ),
      ),
    );
  }

  Widget BuildCards(BuildContext context, List<Video>? list) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refreshPage();
      },
      child: ListView.builder(
          controller: controller,
          itemCount: list?.length ?? 0,
          itemBuilder: (context, index) {
            if (list != null && index < list.length) {
              return Card(
                  child: ListTile(
                      title: Text(list.elementAt(index).title,
                          style:
                              GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
                      subtitle: Text(list.elementAt(index).description,
                              style: GoogleFonts.dmSans()),
                      // Under the description add the upload date
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: Colors.white,
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              list.elementAt(index).thumbnails.standardResUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      trailing: Builder(builder: (context) {
                        return Column(
                          children: [
                            const SizedBox(
                              child: Icon(Icons.play_arrow),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              child: const SizedBox(
                                child: Icon(Icons.bookmark),
                              ),
                            )
                          ],
                        );
                      }),
                      onTap: () {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) {
                            return VideoView(
                                videoId: '${list.elementAt(index).id}');
                          }),
                        );
                      }));
            }
            return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()));
          }),
    );
  }

  Widget returnFutureBuilder() {
    MainView.init_counter_from_rebuild++;
    if (MainView.init_counter_from_rebuild == 1) {
      return FutureBuilder<List<Video>>(
        future: _updateState(),
        builder: (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const ErrorView();
            } else if (snapshot.hasData) {
              return BuildCards(context, MainView.VideosSearchedList);
            } else if (snapshot.data?.isEmpty ?? true) {
              return NoResultsView();
            } else {
              return ErrorView();
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      );
    } else {
      return BuildCards(context, MainView.VideosSearchedList);
    }
  }

  Future _fetchNewData() async {
    MainView.loadingState = true;
    VideosSearched = await appendToSearchList(VideosSearched, context);
    MainView.VideosSearchedList = assignData();
    MainView.loadingState = false;
    comingFromFetch = true;
    setState(() {});
  }

  List<Video> assignData() {
    List<Video> myVideoList = [];
    var videoIterator = VideosSearched.iterator;
    while (videoIterator.moveNext()) {
      myVideoList.add(videoIterator.current);
    }
    MainView.VideosSearchedList = myVideoList;
    return myVideoList;
  }

  Future<List<Video>> _updateState() async {
    // Function used to fill search and user interaction buffers
    MainView.isLoadingState = 1;

    LocalStorageRepository localStorageRepository = LocalStorageRepository();
    Box box = await localStorageRepository.openBox();
    Box box2 = await localStorageRepository.openBoxSavedVideos();
    Box box3 = await localStorageRepository.openBoxVideosHistory();

    List<chan.Channel> channels = localStorageRepository.getChannelList(box);
    SavedVideos.listSavedVideosStatic =
        localStorageRepository.getSavedVideosList(box2);

    // Assign the channel lists
    HistoryView.listHistoryViewStatic =
        localStorageRepository.getVideosHistoryList(box3);
    HistoryView.listHistoryViewStaticNotifier.value =
        HistoryView.listHistoryViewStatic;

    SubscriptionsView.listChannelStatic = channels; // Fill the static variable
    SubscriptionsList.subscriptionsChannel =
        channels; // Fill the buffer for the channels
    SubscriptionsView.listChannelStaticNotifier.value = channels;

    try {
      MainView.loadingState = true;
      if (!comingFromFetch) {
        MainView.searchQuery = HomePage.editingController.text;
        VideosSearched = await getSearch(MainView.searchQuery, context);
        MainView.VideosSearchedList = assignData();

        dataapi.YoutubeDataApi youtubeDataApi = dataapi.YoutubeDataApi();
        YoutubeExplode explodeYt = YoutubeExplode();

        VideoSearchList searchResultNews =
            await explodeYt.search.search("World News");
        VideoSearchList searchResultWeather =
            await explodeYt.search.search("Weather");
        VideoSearchList searchResultEntert =
            await explodeYt.search.search("Entertainment");
        VideoSearchList searchResultSport =
            await explodeYt.search.search("Sport");
        VideoSearchList searchResultTech =
            await explodeYt.search.search("Technology");
        VideoSearchList searchResultPolitics =
            await explodeYt.search.search("Politics");
        VideoSearchList searchResultMusic =
            await explodeYt.search.search("Music");

        // Merge all the results
        List<Video> searchResult = // Concat all lists
            searchResultNews +
                searchResultWeather +
                searchResultEntert +
                searchResultSport +
                searchResultTech +
                searchResultPolitics +
                searchResultMusic;
        DiscoverView.videoListDiscover = searchResult;

        List<vid.Video> trendingVideos =
            await youtubeDataApi.fetchTrendingVideo();
        List<vid.Video> trendingMusicVideos =
            await youtubeDataApi.fetchTrendingMusic();
        List<vid.Video> trendingGamingVideos =
            await youtubeDataApi.fetchTrendingGaming();
        List<vid.Video> trendingMoviesVideos =
            await youtubeDataApi.fetchTrendingMovies();

        // Get the list of videos resulted from searching "World News" using

        TrendingView.videoListTrending =
            trendingMusicVideos; // Assign the variables

        for (int i = 0; i < trendingGamingVideos.length; ++i) {
          TrendingView.videoListTrending.add(trendingGamingVideos.elementAt(i));
        }
        for (int i = 0; i < trendingMoviesVideos.length; ++i) {
          TrendingView.videoListTrending.add(trendingMoviesVideos.elementAt(i));
        }
        for (int i = 0; i < trendingVideos.length; ++i) {
          TrendingView.videoListTrending.add(trendingVideos.elementAt(i));
        }

        TrendingView.videoListTrending
            .shuffle(); // Make the list of elements and mix the categories -> for now

      } else {
        comingFromFetch = false;
      }

      MainView.loadingState = false;
      MainView.isLoadingState = 0;
      return MainView.VideosSearchedList;
    } on Exception catch (e) {
      print("Error: ${e.toString()}");
      return MainView.VideosSearchedList;
    }
  }

  Future<List<Video>> _refreshPage() async {
    // Rebuild the widget
    MainView.wannaRebuild.value = true;
    MainView.wannaRebuild.value = false;
    MainView.init_counter_from_rebuild = 0;

    setState(() async {
      await _updateState();
    });
    return MainView.VideosSearchedList;
  }

   String getVideoDate(String originalDate) {
    // Get the first part of the date before space
    String date = originalDate.split(' ')[0];
    // Split the date into day, month and year
    List<String> dateSplit = date.split('-');
    // Get the month
    String month = dateSplit[1];
    // Get the day
    String day = dateSplit[2];
    // Get the year
    String year = dateSplit[0];
    // Return the date in the format of day month year
    return '$year-$month-$day';
  }
}
