
import 'package:flutter/material.dart';
import 'package:popo/src/views/constants/colors.dart';

class HeaderWidget extends StatefulWidget {
  final String title;
  HeaderWidget(this.title);
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {

  @override
  Widget build(BuildContext context) {
   return  Material(
    elevation: 2.0,
    borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
    ),
    child:Container(
    height: 100.0,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
        ),
     color: primaryColor,
    ),
    child:Center(
      child: Padding(
        padding: const EdgeInsets.only(top:25.0),
        child: Text(widget.title, 
          style: TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:25.0)),
      ),
    )
    )
  );
  }
}
 