import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:popo/models/location.dart';
import 'package:popo/models/news.dart';

class Article extends StatefulWidget {
  final News news;
  Article({this.news});
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  GoogleMapController mapController;
  Location location = Location();
  Marker marker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.news.image),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0,0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:Icon(Icons.arrow_back, size: 25.0),
                          onPressed:()=>Navigator.pop(context),
                        ),
                        SizedBox.shrink()
                       ],
                     ),
                  ),
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:10),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(widget.news.title.toUpperCase(),
                    maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.news.time,
                        maxLines: 1,
                        style: TextStyle(color: Colors.black54,  fontSize: 14),
                      ),
                      IconButton(
                        icon:Icon(Icons.share, color: Colors.black54),
                       onPressed: (){}
                      )
                    ],
                  ),
                Text(widget.news.news,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
