import 'package:firebase_database/firebase_database.dart';

class News{
  String key;
  String title;
  String news;
  String time;
  String image;
  String url;

  News({this.title, this.news, this.time, this.image, this.url});

  News.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    title = snapshot.value["title"],
    news = snapshot.value["news"],
    time = snapshot.value["time"],
    url = snapshot.value["url"],
    image = snapshot.value["image"];

  toJson() {
    return {
      "title": title,
      "news": news,
      "time":time,
      "image":image,
      "url":url,
    };
  }
}