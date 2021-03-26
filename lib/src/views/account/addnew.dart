import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popo/models/station.dart';
import 'package:popo/src/views/account/login.dart';

class AddStation extends StatefulWidget {
  @override
  _AddStationState createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
FirebaseDatabase _database = FirebaseDatabase.instance;
TextEditingController birthDayController = TextEditingController();
final _scaffoldKey =  GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormState>();
String email = "";
String lat;
String long;
String name ="";
String phone ="";
String snippet ="";
String formTitle = "Login";
bool isLoading = false;
bool isUploading = true;
File file;

TextStyle labeStyle = TextStyle(color:Colors.white);
  void uploadImage(context) async {
    setState(() => isUploading = true);
    //Navigator.pop(context);
    //setState(() => isUploading = false);
  }

 void pickImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

Future<String> uploadPhoto() async{
  UploadTask  mStorageUploadTask = FirebaseStorage.instance.ref().child('Images').child("${file.path.toString()}.jpg").putFile(file);
  TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
  String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

 void saveStation()async{
    setState(()=> isLoading = true);
     final form = formKey.currentState;
    if(form.validate()){
      form.save();
      try{
        String url = await uploadPhoto();
          Station station = new Station(name:name, lat: lat,snippet:snippet, long:long, image:url, email:email, phone:phone);
        _database.reference().child("Stations").push().set(station.toJson());
      }catch(e){
        SnackBar snackBar = SnackBar(content: Text("Error: " + e.toString()));
          _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
    setState(()=> isLoading = false);
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
       backgroundColor:Colors.black87,
      appBar: AppBar(
        backgroundColor:Colors.black87,
        title:Text("AddStation"),
        centerTitle: true,
      ),
      body:GestureDetector(
        onTap:()=>FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/badge.png"),
              fit: BoxFit.contain
            )
          ),
          child: SingleChildScrollView(
            child: Container(
              color:Colors.black54,
               height:700.0,
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Column(
                   children: <Widget>[
                    SizedBox(height:100.0),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: createInput() + createButtons() + [SizedBox(height: 30.0,)],
                        ),
                      ),
                    ),
                 ],
                ),
              )
            ),
          )
         ),
      )
    );
  }

  List<Widget> createInput(){
    return[
         file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Container(
                width: 100.0,
                height: 100.0,
                child: Image.file(
                  file,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Container(
                  color: Colors.grey[200],
                  width: 150.0,
                  height: 150.0,
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () => pickImage(),
                  )),
            ),
        TextFormField(
         style:labeStyle,
         keyboardType: TextInputType.text,
         textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white), ),
          labelText: 'Station',
           labelStyle: labeStyle,
          ),
          
          validator: (value){
          return value.isEmpty ? 'Name is required ': null;
        },
        onSaved:(value){
          return name = value;
        } ,
        ),
       SizedBox(height: 20.0,),
       TextFormField(
         style:labeStyle,
         keyboardType: TextInputType.text,
         textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white), ),
          labelText: 'Snippet',
           labelStyle: labeStyle,
          ),
          
          validator: (value){
          return value.isEmpty ? 'Name is required ': null;
        },
        onSaved:(value){
          return snippet = value;
        } ,
        ),

       TextFormField(
        style:labeStyle,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense:true ,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0) ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
          fillColor: Colors.deepPurple.shade100,
          labelText: 'Email',
           labelStyle: labeStyle,
           ),
        validator: (value){
          return value.isEmpty ? 'Email is required' : null;
        },
         onSaved:(value){
          return email = value;
        } ,
        ),
        
        SizedBox(height: 20.0,),

       TextFormField(
         style:labeStyle,
         keyboardType: TextInputType.phone,
         textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white), ),
          labelText: 'Phone Number',
           labelStyle: labeStyle,
          ),
          validator: (value){
          return value.isEmpty ? 'Phone number is required ': null;
        },
        onSaved:(value){
          return phone = value;
        } ,
        ),
         TextFormField(
         style:labeStyle,
         keyboardType: TextInputType.number,
         textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
          labelText:'Long',
           labelStyle: labeStyle,
          ),
          validator: (value){
          return value.isEmpty ? 'Phone number is required ': null;
        },
        onSaved:(value){
          return long = value;
        } ,
        ),
         TextFormField(
         style:labeStyle,
         keyboardType: TextInputType.number,
         textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white), ),
          labelText: 'Latitude',
           labelStyle: labeStyle,
          ),
          validator: (value){
          return value.isEmpty ? 'Phone number is required ': null;
        },
        onSaved:(value){
          return lat = value;
        } ,
        ),
         SizedBox(height: 20.0,),
         
    ];
   }
  

  
  List<Widget> createButtons(){
      return[
         Padding(
        padding: const EdgeInsets.only(top:10.0,),
          child:GestureDetector(
                 onTap:()=>saveStation(),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color:Colors.red,
                      borderRadius: BorderRadius.circular(8.0),),
                    child: Center(
                      child:  isLoading ? 
                       SizedBox(
                        width: 20.0, height: 20.0,
                        child: CircularProgressIndicator( 
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.0,
                        ),
                      ) : Text("AddStation", style: TextStyle(
                        color:Colors.white, fontWeight: FontWeight.w700, 
                      ),),
                    ),
                  ),
            ), 
          ),
    ];
   }
  }