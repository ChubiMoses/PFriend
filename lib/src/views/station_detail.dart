import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:popo/models/location.dart';
import 'package:popo/models/station.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetail extends StatefulWidget {
  final Station station;
  StationDetail({this.station});
  @override
  _StationDetailState createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  GoogleMapController mapController;
  Location location = Location();
  Set<Marker> _markers = HashSet<Marker>();
  int _markerIdCounter = 1;
  Marker marker;

  @override
  void initState() {
    super.initState();
    _setMarkers(double.parse(widget.station.lat), double.parse(widget.station.long));
  }

  void _setMarkers(double lat, double long) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(markerIdVal),
          position: LatLng(double.parse(widget.station.lat), double.parse(widget.station.long)),
          infoWindow: InfoWindow(
            title:widget.station.name,
            snippet:widget.station.snippet
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.station.lat), double.parse(widget.station.long)),
               zoom: 16.0),
          zoomGesturesEnabled: false,
          myLocationEnabled: true,
          markers: _markers,
        ),
        Container(
          height: 240.0,
          child: Material(
            elevation: 1.0,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.station.image),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width - 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.station.name,overflow: TextOverflow.ellipsis,style:
                            TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                            Text("", style:Theme.of(context).textTheme.caption
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.call, size: 14.0),
                              onPressed:()=>_launchPhone("tel:${widget.station.phone}"),
                              ),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            radius: 14.0,
                          ),
                            SizedBox(width:5.0,),
                          CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.email, size: 14.0),
                              onPressed:()=>_launchMail(),
                              ),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            radius: 14.0,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  
   _launchMail() async{
     final Uri params = Uri(
       scheme:"mailto",
       path:  "helloccapps@gmail.com",
       query: "subject=MyCBT 1.0",
     );
      final url = params.toString();
      if(await canLaunch(url)){
        await launch(url);
      }else{
        throw "Could not lanch" + url;
      }
   }

   void _launchPhone(String phone) async{
    await canLaunch(phone) ? 
    await launch(phone) : throw 'Could not launch $phone';
    }

}
