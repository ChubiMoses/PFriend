import 'package:popo/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyA_7M5iaiTeP6kIJt4h6_iKBZMPx7r938A';

  Future<List<Place>> getPlaces(double lat, double lng, BitmapDescriptor icon) async {
    String url ='https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=police&rankby=distance&key=$key';
    var response = await http.get(Uri.parse(url), headers: {'Accept' : 'application/json'});
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place,icon)).toList();
  }

}