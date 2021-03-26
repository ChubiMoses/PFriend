import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:popo/services/geolocator_service.dart';
import 'package:popo/src/views/constants/colors.dart';
import 'package:popo/src/views/station_view.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final geoService = GeoLocatorService();
    return Scaffold(
      backgroundColor:primaryColor,
      body: (currentPosition != null)
            ? FutureProvider(
      create: (context)=>geoService.getLocationName(currentPosition.latitude, currentPosition.longitude),
      child:Consumer<String>(
        builder: (context, name, widget) {
        return   (name != null)
              ?  Column(
          children: [
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:50.0),
                  CircleAvatar(
                    radius:40.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size:50.0),
                  ),
                   SizedBox(height:5.0),
                  Text("John Doe", style: TextStyle(color:white,fontSize:18.0)),
                  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_pin,size: 18.0, color:white), 
                      Text(name,style: TextStyle(color:white, fontSize:14.0)),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight:Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: white,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemCount: Profile.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i){
                    return Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(25.0)),
                      child: ListTile( 
                       onTap:()=>Navigator.push(context, MaterialPageRoute(builder:(context)=>StationView(lat:29.9773,long:31.1325))),
                        dense: true,
                        leading:CircleAvatar(
                          child: Icon(Icons.person, color:primaryColor),
                          backgroundColor:Colors.grey[200],
                          radius:25.0,
                          ),
                        title:Text("${Profile[i]['category']}",style: TextStyle(color:Colors.black87, fontSize:16.0)),
                        subtitle:Row(
                          children: [
                            Text("${Profile[i]['name']}", style:Theme.of(context).textTheme.caption),
                            Icon(Icons.check_circle, size: 10.0,color:Profile[i]['status'] == 0 ? primaryColor :grey),
                          ],
                        ),
                        trailing:Icon(Icons.launch_outlined, size: 18.0,),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ): Center(child: CircularProgressIndicator());
        }
       )
      ) : Text("Loading"),
    );
  }

  var Profile =  [
    {
      'name' : 'Division 4 Makurdi',
      'status' : 0,
      'category' : "Rubbery",
    },
    {
      'name' : 'Division 3 Makurdi',
      'status' : 1,
      'category' : "Sexual Assualt",
    },
    {
      'name' : 'Division 2 Makurdi',
      'status' : 0,
      'category' : "Kidnapping",
    },
    {
      'name' : 'Division 1 Makurdi',
      'status' : 2,
      'category' : "Kidnapping",
    },
  ];
}