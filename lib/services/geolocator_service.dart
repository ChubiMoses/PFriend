//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocatorService{
  
  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  
 Future<String>getLocationName(double lat, double long)async{
   //List<Location> location await  locationFromAddress("Makrdi 123, njj");
   try{
    //  List<Placemark> placemarks = await placemarkFromCoordinates(lat,long);
    //  Placemark mPlaceMark = placemarks[0];
    //  //String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country}';
    //  String address = '${mPlaceMark.name}, ${mPlaceMark.subThoroughfare}, ${mPlaceMark.thoroughfare}, ${mPlaceMark.country}';
    //  return address;
   }catch(e){
    print("Eror");
   }
   return "Hello";
 }

  Future<double> getDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
   return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }


}