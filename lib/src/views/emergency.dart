import 'package:flutter/material.dart';
import 'package:popo/src/views/constants/colors.dart';
import 'package:popo/src/widgets/drawer_widget.dart';
import 'package:popo/src/widgets/hearderWidget.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer:DrawerWidget(),
      appBar: AppBar(
        title:Text("Emergency Messages")
      ),
      body:CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal:15.0,vertical:18),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(buttonTiles, childCount:items.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.05,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0
                    )),
              )
            ],
          )
    );
  }

 Widget buttonTiles(BuildContext context, int i){
    return Material(
      elevation: 0.0,
      color:Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Image(
              image:AssetImage(items[i]['image']),
              height: 60.0,
              width: 60.0,
            ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(items[i]['name'], 
            textAlign: TextAlign.center, 
            style: TextStyle(
                color:black,
                fontSize: 14,
                fontWeight: FontWeight.w400,),
            ),
          ),
        ],
      ),
    );
  }


}


  var items = [
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Robbery',
    },
    {
      'image' : 'assets/images/crime.png',
      'name' : 'Homicide',
    },
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Sexual Assualt',
    },
    {
      'image' : 'assets/images/handcuffs.png',
      'name' : 'Sabbotage',
    },
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Thief',
    },
    {
      'image' : 'assets/images/gun.png',
      'name' : 'Nursing',
    },
  ];
