import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:popo/models/user.dart';
import 'package:popo/src/views/account/Authentication.dart';
import 'package:popo/src/views/report/send_report.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SendReport extends StatefulWidget {
  final User  user;
  final LatLng position;
  SendReport({this.user, this.position});
  @override
  _SendReportState createState() => _SendReportState();
}

class _SendReportState extends State<SendReport> {
   int index;
    User user;
    AuthImplementation auth = Auth();
    DatabaseReference databaseReference;
     
      Future getUserInfo() async {
      String userId =  await auth.getCurrentUser();
       databaseReference = FirebaseDatabase.instance.reference().child("Users").child(userId);
       databaseReference.once().then((DataSnapshot dataSnapshot){
           setState(() {
              user = User(
              key: dataSnapshot.key,
              name: dataSnapshot.value['name'],
              long: dataSnapshot.value['long'],
              phone: dataSnapshot.value['phone'],
              email:dataSnapshot.value['email'],
              lat: dataSnapshot.value['lat'],
              image: dataSnapshot.value['image']
            );
           });
       });
    }

  @override
  void initState() { 
    super.initState();
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    getUserInfo();
  }
 
   @override
      Widget build(BuildContext context) {
        final currentPosition = Provider.of<Position>(context);
        return Scaffold(
          body: (currentPosition != null)
            ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentPosition.latitude,
                            currentPosition.longitude),
                        zoom: 16.0),
                    zoomGesturesEnabled: true,
                    //markers: Set<Marker>.of(markers),
                  ),
                   reportWidget(),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
        );
      }

      Widget reportWidget(){
        return Container(
          color:Colors.red.withOpacity(0.9),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height:20.0),
                      CircleAvatar(
                         radius:54.0,
                         backgroundColor:Colors.white,
                        child: CircleAvatar(
                          radius:50.0,
                          backgroundColor:Colors.red,
                          child:Icon(Icons.person, size:50.0),
                        ),
                      ),
                      SizedBox(height:5.0),
                      Text(user != null ? user.name : "User", style: TextStyle(color:Colors.white,fontSize:18.0)),
                    ],
                  ),
                ),
                Container(
                  height: 170.0,
                  child:GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal:20.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 8.0
                    ),
                    itemCount: items.length,
                    itemBuilder:(context, i){
                     return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              shape: BoxShape.rectangle,
                              border:i == index ? null : Border.all(
                                color:Colors.white, width: 1.0
                              ) 
                            ),
                            child: InkWell(
                              onTap:(){
                                 setState(()=>index = i);
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (sheetContext) => BottomSheet(
                                    onClosing: () {},
                                    builder: (_)=>SendNow(report:items[i]['name'], position:widget.position,user:user))
                                    );
                              },
                              child: Center(
                                child: Text(items[i]['name'],
                                style:TextStyle(color: i == index ? Colors.white : Colors.white, fontSize: 12.0),
                                ),
                              ),
                            ),
                          );
                    }
                  )
                ),
              ],
            ),
        );
      }
}

  var items = [
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Robbery',
    },
    {
      'image' : 'assets/images/crime.png',
      'name' : 'Homicide',
    },
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Sexual Assualt',
    },
    {
      'image' : 'assets/images/handcuffs.png',
      'name' : 'Sabbotage',
    },
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Theft',
    },
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Fire',
    },
  ];
