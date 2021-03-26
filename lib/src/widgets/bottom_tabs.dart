
import 'package:flutter/material.dart';
import 'package:popo/src/views/constants/colors.dart';
dynamic bottomTabs(context, IconData icon, String label){
    return BottomNavigationBarItem(
            icon: Icon(icon, size: 25.0),
            activeIcon: Container(
              width: 70.0,
             decoration: BoxDecoration(
                color:primaryColor,
                borderRadius: BorderRadius.circular(30.0)
             ),
              child:Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 22.0, color:white),
                  SizedBox(width:4.0),
                  Text(label, style: TextStyle(fontSize: 13.0, color:white)),
                ],
            ),
              )),
            );
   }
  