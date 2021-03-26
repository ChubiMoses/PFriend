import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationView extends StatefulWidget {
  final double lat;
  final double long;
  StationView({this.lat, this.long});

  @override
  _StationViewState createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  GoogleMapController mapController;
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circle = HashSet<Circle>();
  int _markerIdCounter = 1;
  int _circleIdCounter = 1;
  Marker marker;

  @override
  void initState() { 
    super.initState();
    _setMarkers(widget.lat, widget.long);
  }

    void _setMarkers(double lat, double long){
     final String markerIdVal = 'marker_id_$_markerIdCounter';
     _markerIdCounter++;
     setState(() {
       _markers.add(
         Marker(
           markerId: MarkerId(markerIdVal),
           position:LatLng(widget.lat, widget.long),
           infoWindow:InfoWindow(
             title:"Police Division II",
             snippet: '*'
           )
         )
       );
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated:(GoogleMapController controller){
                  mapController = controller;
                },
                initialCameraPosition:CameraPosition(target: LatLng(widget.lat, widget.long),
                zoom: 16.0),
                zoomGesturesEnabled: true,
                myLocationEnabled:true,
                markers:_markers,
                circles:_circle,
                onTap:(point){
                  setState((){
                   // _markers.clear();
                  // _setMarkers(point);
                  });
                },
              ),
            )
    );
  }
}
