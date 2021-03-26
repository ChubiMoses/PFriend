import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:popo/models/report.dart';
import 'package:popo/models/station.dart';
import 'package:popo/models/user.dart';
import 'package:popo/src/views/constants/colors.dart';
import 'package:popo/src/views/station_detail.dart';

class SendNow extends StatefulWidget {
  final User  user;
  final LatLng position;
   final String report;
  SendNow({this.user, this.position, this.report});
  @override
  _SendNowState createState() => _SendNowState();
}
 
class _SendNowState extends State<SendNow> {
  int count = 5;
  Timer t;
  LatLng  latLng;
  List<Station> stations = [];
  List<double> distance = [];
  bool reportSent = false;
  DatabaseReference databaseReference;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  Station pStation;

   @override
  void initState() {
    databaseReference = FirebaseDatabase.instance.reference().child("Stations");
    databaseReference.onChildAdded.listen(_onAddData);
    counDown();
    super.initState();
  } 

    Future getLocation() async {
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
       latLng = LatLng(position.latitude,position.longitude);
     });
     }
    
   void _onAddData(Event event){
    setState((){
      stations.add(Station.fromSnapshot(event.snapshot));
    });
   //calculate stations distance
   print(stations);
   stations.forEach((data){
      double dist =  Geolocator.distanceBetween(latLng.latitude, latLng.longitude, double.parse(data.lat),  double.parse(data.long));
      distance.add(dist);
   });
  //find the shortest distance
   double closestDistance = distance.reduce(min);
   int stationIndex = distance.indexOf(closestDistance);
   // Closest police station station
   setState(()=>pStation = stations[stationIndex]);
  }

 void sendReport(){
    Report report = new Report(name:"Chubi", stationId:pStation.key, image :"Chubi", lat: 23243.5,  long: 3546.6, category:widget.report, phone:"Chubi", email:"Chubi");
    _database.reference().child("Reports").push().set(report.toJson());
 }

 void counDown(){
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (t) {
      setState(() {
        if(count < 1) {
          t.cancel();
         // sendReport();
          reportSent = true;
        } else {
          count = count - 1;
        }
      });
    });
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              color:primaryColor,
              child:Text("Sending ${widget.report} Report...", style: TextStyle(color:Colors.white, fontSize:18.0)),
            ),
            SizedBox(height:80.0),
            Container(
              alignment: Alignment.center,
              width: 130.0,
              height: 130.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      color:primaryColor,
                    border:Border.all(
                      color:Colors.red.shade100, width: 8.0
                    ) 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:reportSent ? Icon(Icons.check, size:70.0, color:white,) : Text(count.toString(),
                    style:TextStyle(color: white, fontSize: 80.0, fontWeight:FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height:10.0),
                !reportSent ?
                 RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: primaryColor,
                  child: Text("Cancel"),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0)
                )
                ) :
                OutlineButton(
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(context)=>StationDetail())),
                  borderSide:BorderSide(color:primaryColor),
                  child: Text("Report Info"),
                  textColor:primaryColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0)
                )
              )
          ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t.cancel();
  }
}