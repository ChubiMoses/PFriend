import 'package:firebase_database/firebase_database.dart';

class User{
  String key;
  String name;
  String phone;
  String email;
  double lat;
  double long;
  String image;
  String gender;
  String userId;

  User({this.name, this.userId, this.lat, this.gender, this.image, this.long, this.phone, this.email});

  User.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    name = snapshot.value["name"],
    userId = snapshot.value["userId"],
    phone = snapshot.value["phone"],
    email = snapshot.value["email"],
    lat = snapshot.value["lat"],
    image = snapshot.value["image"],
    gender = snapshot.value["gender"],
    long = snapshot.value["long"];

  toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "lat":  lat,
      "long": long,
      "gender": gender,
      "image":image,
      "userId":userId,
    };
  }
}