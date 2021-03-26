import 'package:firebase_database/firebase_database.dart';

class Station{
  String key;
  String name;
  String phone;
  String email;
  String lat;
  String long;
  String image;
   String snippet;

  Station({this.name,this.lat,this.snippet, this.long, this.phone,this.image, this.email});

  Station.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    name = snapshot.value["name"],
    phone = snapshot.value["phone"],
    email = snapshot.value["email"],
    lat = snapshot.value["lat"],
    image = snapshot.value["image"],
    snippet = snapshot.value["snippet"],
    long = snapshot.value["long"];

  toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "lat":  lat,
      "long": long,
      "image": image,
      "snippet": snippet,
    };
  }
}