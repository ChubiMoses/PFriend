
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:popo/models/user.dart';
import 'package:popo/src/views/account/Authentication.dart';
import 'package:popo/src/views/map_view.dart';
import 'package:popo/src/views/recent.dart';
import 'package:popo/src/views/report.dart';
import 'package:popo/src/widgets/bottom_tabs.dart';


class HomeTabs extends StatefulWidget {
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  AuthImplementation auth = Auth();
   DatabaseReference databaseReference;
 final _scaffoldKey =  GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime;
  PageController pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  LatLng latLng;
  User user;
 
   Future getLocation() async {
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     setState(() {
       latLng = LatLng(position.latitude,position.longitude);
     });
    }


    Future getUserInfo() async {
      String userId =  await auth.getCurrentUser();
       databaseReference = FirebaseDatabase.instance.reference().child("Users").child(userId);
       databaseReference.once().then((DataSnapshot dataSnapshot){
       // user =  User.fromSnapshot(dataSnapshot).toJson();
        print(user);

        var keys = dataSnapshot.value.keys;
        var data = dataSnapshot.value;
        for  (var key in keys){
          User d = new User(
            name: data[key]['name'],
            long: data[key]['long'],
            phone: data[key]['phone'],
            email: data[key]['email'],
            lat: data[key]['lat'],
            image: data[key]['image']
          );
         setState(() {
           user = d;
         });
        }
       
        setState((){
          //  user =  User.fromSnapshot(dataSnapshot).toJson();
          // for(var val in dataSnapshot.value.entries){
          //   user =  User(email:val.email,name:val.name,image:val.emage,phone:val.phone,lat:val.lat,long:val.long, gender:val.gender);
          // }
        });
       });
    }
  @override
  void initState(){ 
    super.initState();
    getLocation();
    pageController = PageController();
  }

 
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
  void whenPageChanges(int pageIndex){
      setState(() {
        this.getPageIndex = pageIndex;
      });
    }

  void onTapChangePage(int pageIndex){
      pageController.animateToPage(pageIndex,
       duration: Duration(milliseconds: 400),
        curve: Curves.bounceInOut);
    }

  Scaffold buildHomeTabs(){
    return Scaffold(
      key:_scaffoldKey,
     body: PageView(
       children: <Widget>[
         MapView(),
         Recent(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics()
     ),
      
     bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        activeColor:Colors.white,
        inactiveColor:Colors.black,
        backgroundColor:Colors.white,
        border: Border(top:BorderSide.none),
        items:[
          bottomTabs(context,Icons.location_on, "Map"),
          bottomTabs(context,Icons.bookmark,"News"),
             ],
        ),
        floatingActionButton:Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              width:5.0,
              color: Colors.white
            ),
          ),
          child: InkWell(
            onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SendReport(user:user, position:latLng))),
            child: new Container(
              width:50.0,
              height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
                 color: Colors.red
              ),
               child:Icon(Icons.add,size:18.0, color:Colors.white),
           ),
          ),
        ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()=>onWillPop(),
      child:buildHomeTabs()
      );
  }

   Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backbuttonpressedTime == null ||
    currentTime.difference(backbuttonpressedTime) > Duration(seconds:3);
    if(backButton) {
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
