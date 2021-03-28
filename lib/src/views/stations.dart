import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:popo/models/station.dart';
import 'package:provider/provider.dart';
import 'package:popo/src/views/station_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class Stations extends StatefulWidget {
  @override
  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  Set<Marker> _markers = HashSet<Marker>();
  DatabaseReference databaseReference;
  int _markerIdCounter = 1;
  List<Station> stations = [];
  Set<Circle> _circle = HashSet<Circle>();
  int _circleIdCounter = 1;
  Marker marker;

  @override
  void initState() {
    getLocation();
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    databaseReference = FirebaseDatabase.instance.reference().child("Stations");
    databaseReference.onChildAdded.listen(_onAddData);
    super.initState();
  }

  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setCircle(position.latitude, position.longitude);
  }

  void setMarkers(double lat, double long, String name, String snippet) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(markerIdVal),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(title: name, snippet: snippet)));
    });
  }

  void setCircle(
    double lat,
    double long,
  ) {
    final String circleIdVal = 'marker_id_$_circleIdCounter';
    _circleIdCounter++;
    setState(() {
      _circle.add(Circle(
        circleId: CircleId(circleIdVal),
        center: LatLng(lat, long),
        radius: 400,
        fillColor: Colors.red.shade100,
        strokeWidth: 3,
        strokeColor: Colors.redAccent,
      ));
    });
  }

  void _onAddData(Event event) {
    setState(() {
      stations.add(Station.fromSnapshot(event.snapshot));
    });
    stations.forEach((data) {
      double lat = double.parse(data.lat);
      double long = double.parse(data.long);
      setMarkers(lat, long, data.name, data.snippet);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    return Scaffold(
        body: Container(
      child: Stack(
        children: [
          (currentPosition != null)
              ? GoogleMap(
                  circles: _circle,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          currentPosition.latitude, currentPosition.longitude),
                      zoom: 12.0),
                  zoomGesturesEnabled: true,
                  markers: _markers,
                )
              : Center(child: CircularProgressIndicator()),
          Container(
            height: 190.0,
            child: FirebaseAnimatedList(
                query: databaseReference,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StationDetail(station: stations[index]))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        elevation: 2.0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 140.0,
                                width: 200.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      stations[index].image),
                                  fit: BoxFit.cover,
                                )),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(4.0, 3.0, 4.0, 0.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 130.0,
                                    child: Text(stations[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16.0)),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  CircleAvatar(
                                    child: IconButton(
                                      icon: Icon(Icons.call, size: 14.0),
                                      onPressed: () => _launchPhone(
                                          "tel:${stations[index].phone}"),
                                    ),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    radius: 14.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  CircleAvatar(
                                    child: IconButton(
                                      icon: Icon(Icons.email, size: 14.0),
                                      onPressed: () =>_launchMail(stations[index].email),
                                    ),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    radius: 14.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    )
        //  : Center(child: CircularProgressIndicator()),
        );
  }

  _launchMail(String email) async {
    final Uri params = Uri(
      scheme: "mailto",
      path: email,
      query: "subject=Emergency Report",
    );
    final url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not lanch" + url;
    }
  }

  void _launchPhone(String phone) async {
    await canLaunch(phone)
        ? await launch(phone)
        : throw 'Could not launch $phone';
  }
}
