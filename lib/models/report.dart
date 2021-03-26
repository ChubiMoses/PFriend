import 'package:firebase_database/firebase_database.dart';

class Report{
  String key;
  String stationId;
  String name;
  String phone;
  String email;
  double lat;
  double long;
  String image;
   String category;

  Report({this.name, this.stationId, this.lat, this.category, this.image, this.long, this.phone, this.email});

  Report.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    category = snapshot.value["category"],
    name = snapshot.value["name"],
    phone = snapshot.value["phone"],
    email = snapshot.value["email"],
    lat = snapshot.value["lat"],
    image = snapshot.value["image"],
    stationId = snapshot.value["stationId"],
    long = snapshot.value["long"];

  toJson() {
    return {
      "stationId": stationId,
      "name": name,
      "category": category,
      "phone": phone,
      "email": email,
      "lat":  lat,
      "long": long,
      "image":image,
    };
  }
}