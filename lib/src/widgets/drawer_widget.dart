
import 'package:flutter/material.dart';
import 'package:popo/src/views/constants/colors.dart';

class DrawerWidget extends StatefulWidget{
  final List<dynamic> menuList = menus;
  _DrawerWidget createState() => _DrawerWidget();
}

class _DrawerWidget extends State<DrawerWidget>{
   String username;
   String url;
   bool loading = true;
   String email;
   Color color;
   String number;
   int i = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      for(int i = 0; i < widget.menuList.length; i++ ){
      if (ModalRoute.of(context).settings.name.toString() == widget.menuList[i]['route']) {
        widget.menuList[i]['active'] = true;
      } else widget.menuList[i]['active'] = false;
    }
    });
    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:20.0),
            Container(
              height: 155.0,
              width: MediaQuery.of(context).size.width,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child:Icon(Icons.shopping_bag, color:primaryColor, size:40.0),
                    radius: 30.0,
                    backgroundColor: Colors.grey[100],
                  ),
                  SizedBox(width:5.0),
                 Text("Who_Dey_Sell", style:TextStyle(color:color, fontWeight: FontWeight.bold)),
                ],
              )
          ),

            Expanded(
              child: Material(
                child: ListView.builder(  
                padding: EdgeInsets.all(0),       
                itemCount: widget.menuList.length,
                shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index){
                    return InkWell(
                      onTap: ()async{
                         // Navigator.pushNamed(context, widget.menuList[index]['route']);
                        },
                      child: Container(
                        margin:EdgeInsets.only(left:0, right:0),
                        color: widget.menuList[index]['active'] ? primaryColor : Colors.transparent,
                        child: ListTile(  
                          dense: true, 
                          leading: Icon(widget.menuList[index]['icon'], color: widget.menuList[index]['active'] ? Colors.white:black),                                  //the item
                          title: Text(widget.menuList[index]['name'],
                           style:TextStyle(color: widget.menuList[index]['active'] ? Colors.white : Colors.black87, fontSize: 14.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),

               Container(
                  child:Text("2021 \u00a9 buildspace", style:Theme.of(context).textTheme.caption),
                )
          ]
        ),
      )
    );
  }
}
var menus = [
    {
      'name' : 'Category',
      'icon' : Icons.menu,
      'route' : '/invite',
      'active' : false,
    },
    {
      'name' : 'Share App',
      'icon' : Icons.share,
      'route' : '/invite',
      'active' : false,
    },
   
  
    {
      'name' : 'Settings',
      'icon' : Icons.settings_applications,
      'route' : '/invite',
      'active' : false,
    },

     {
      'name' : 'Feedback',
      'icon' : Icons.comment_bank,
      'route' :'/invite',
      'active' : false,
    },
  ];

