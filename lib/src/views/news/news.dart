import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:popo/models/news.dart';
import 'package:url_launcher/url_launcher.dart';

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  DatabaseReference databaseReference;
  List<News> news = [];
  @override
  void initState() {
    databaseReference = FirebaseDatabase.instance.reference().child("News");
    databaseReference.onChildAdded.listen(_onAddData);
    super.initState();
  }

  void _onAddData(Event event) {
    setState(() {
      news.add(News.fromSnapshot(event.snapshot));
    });
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not lanch " + url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: news.length != 0
            ? FirebaseAnimatedList(
                query: databaseReference,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, DataSnapshot snapshot,
                    Animation<double> animation, int i) {
                  return GestureDetector(
                    onTap: () => launchURL(news[i].url),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        elevation: 1.0,
                        child: Column(
                          children: [
                            Container(
                              height: 140.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: CachedNetworkImageProvider(news[i].image),
                                fit: BoxFit.cover,
                              )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(news[i].title.toUpperCase(),
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        news[i].time,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.share,
                                              color: Colors.black54),
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Can't share at the moment.",
                                                backgroundColor: Colors.black54,
                                                textColor: Colors.white);
                                            return false;
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Center(child: CircularProgressIndicator()));
  }
}
