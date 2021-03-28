import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:popo/models/place.dart';
import 'package:popo/services/geolocator_service.dart';
import 'package:popo/services/places_service.dart';
import 'package:popo/src/views/account/mapping.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context) {
          ImageConfiguration configuration = createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(configuration, 'assets/images/parking-icon.png');
        }),
        ProxyProvider2<Position,BitmapDescriptor,Future<List<Place>>>( 
          update: (context,position,icon,places){
            return (position !=null) ? placesService.getPlaces(position.latitude, position.longitude,icon) :null;
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        title: 'PFriend',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.red,
        ),
        home: Mapping(),
      ),
    );
  }
}
