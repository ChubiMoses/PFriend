import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:popo/models/user.dart';
import 'package:popo/src/views/account/Authentication.dart';
import 'package:popo/src/views/stations.dart';
import 'package:popo/src/views/news.dart';
import 'package:popo/src/views/emergency_buttons.dart';
import 'package:popo/src/widgets/bottom_tabs.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthImplementation auth = Auth();
  DatabaseReference databaseReference;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime;
  PageController pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  LatLng latLng;
  User user;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  void onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeView() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
          children: <Widget>[
            Stations(),
            Recent(),
          ],
          controller: pageController,
          onPageChanged: whenPageChanges,
          physics: NeverScrollableScrollPhysics()),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        activeColor: Colors.white,
        inactiveColor: Colors.black,
        backgroundColor: Colors.white,
        border: Border(top: BorderSide.none),
        items: [
          bottomTabs(context, Icons.location_on, "Map"),
          bottomTabs(context, Icons.list_alt, "News"),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(width: 5.0, color: Colors.white),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SendReport())),
          child: new Container(
            width: 50.0,
            height: 50.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(Icons.add, size: 18.0, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () => onWillPop(), child: buildHomeView());
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double click to exit app",
          backgroundColor: Colors.black54,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}
