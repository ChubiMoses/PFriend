import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:popo/models/report.dart';
import 'package:popo/models/station.dart';
import 'package:popo/models/user.dart';

class SendNow extends StatefulWidget {
  final User user;
  final LatLng position;
  final String report;
  SendNow({this.user, this.position, this.report});
  @override
  _SendNowState createState() => _SendNowState();
}

class _SendNowState extends State<SendNow> {
  int count = 5;
  Timer t;
  LatLng latLng;
  List<Station> stations = [];
  List<double> distance = [];
  bool reportSent = false;
  DatabaseReference databaseReference;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String stationId;

  @override
  void initState() {
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    getStations();
    counDown();
    super.initState();
  }

  void getStations() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    databaseReference = FirebaseDatabase.instance.reference().child("Stations");
    databaseReference.once().then((DataSnapshot dataSnapshot) {
      dataSnapshot.value.forEach((key, data) {
        setState(() {
          stations.add(
          Station(
            key:key,
            name: data['name'],
            lat: data['lat'],
            long: data['long'],
            phone: data['phone'],
            email: data['email'],
          ));
        });
      });
      //Get police stations distance from the user
      stations.forEach((data) {
        double dist = Geolocator.distanceBetween(
            position.latitude,
            position.longitude, 
            double.parse(data.lat),
            double.parse(data.long));
        distance.add(dist);
      });

      //find the nearest police station
      double closestDistance = distance.reduce(min);
      int stationIndex = distance.indexOf(closestDistance);
      stationId = stations[stationIndex].key;
      try {
        //Send emergency message to the nearest police station
        Report report = new Report(
            name: widget.user.name,
            stationId: stationId,
            image: widget.user.image,
            lat: position.latitude,
            long: position.longitude,
            category: widget.report,
            phone: widget.user.phone,
            email: widget.user.email);
        _database.reference().child("Reports").push().set(report.toJson());
        reportSent = true;
        
      } catch (e) {
        print(e);
      }
    });
  }

  //Display counter
  void counDown() {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (t) {
      setState(() {
        if (count < 1) {
          t.cancel();
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
          color: Colors.red,
          child: Text("Sending ${widget.report} Report...",
              style: TextStyle(color: Colors.white, fontSize: 18.0)),
        ),
        SizedBox(height: 80.0),
        Container(
          alignment: Alignment.center,
          width: 130.0,
          height: 130.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              border: Border.all(color: Colors.red.shade100, width: 8.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: reportSent
                ? Icon(
                    Icons.check,
                    size: 70.0,
                    color:Colors.white,
                  )
                : Text(
                    count.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 80.0,
                        fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        SizedBox(height: 10.0),
        !reportSent
            ? SizedBox.shrink()
            : OutlineButton(
                onPressed: () => Navigator.pop(context),
                borderSide: BorderSide(color: Colors.red),
                child: Text("Report Sent"),
                textColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)))
      ],
    );
  }
}
