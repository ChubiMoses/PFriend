
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popo/src/home_tabs.dart';


class UploadProfileImage extends StatefulWidget {
  final String userId;
  UploadProfileImage({this.userId});
  @override
  _UploadProfileImageState createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  String path;
  File file;
  final _scaffoldKey =  GlobalKey<ScaffoldState>();
  bool _uploading = false;
  bool enableUpload = false;

void pickImageFromGallery() async {    
     File imageFile = await ImagePicker.pickImage(
     source: ImageSource.gallery,
     maxHeight: 680,
     maxWidth: 970
     );
     setState(() {
       this.file = imageFile;
     });
}


 

Future uploadPhoto() async{
  //  UploadTask  mStorageUploadTask = storageReference.child("Profile_$id.jpg").putFile(file);
  // TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
  // String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  // return downloadUrl;
}

void  savePhoto(context) async{
  setState(() {
    _uploading = true;
  });

  String downloadUrl = await uploadPhoto();
  // usersReference.doc(widget.userId).update({
  //       "url":downloadUrl,
  //    });
   setState(() {
    _uploading = false;
    file = null;
  });
  // displayToast("Updating...");
   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: 
   (BuildContext context)=>HomeTabs()),(Route<dynamic>route)=>false);
 } 

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       key: _scaffoldKey,
      appBar:AppBar(
         title:Text("Update profile photo", style: TextStyle(color:Colors.black)),
       ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
              children: <Widget>[
                SizedBox(height:50.0),
                file != null ?  
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child:Container(
                    width: 150.0,
                    height: 150.0,
                    child: Image.file(file, height:200, fit: BoxFit.cover,),
                  ),
                )
                :
                CircleAvatar(
                  radius: 70.0,
                  backgroundColor: Colors.grey[300],
                  child:IconButton(
                    icon:Icon(Icons.add_a_photo, size: 40.0, color: Colors.black87,),
                     onPressed: ()=>pickImageFromGallery()
                     ),
                  ),
                      SizedBox(height:10.0),
                   file == null ? 
                   OutlineButton(
                     onPressed: ()=>pickImageFromGallery(),
                     child: Text("Select Image", style:Theme.of(context).textTheme.button),
                     color:Colors.red,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30.0)
                     ),
                     ) :
                   
                    Padding(
                    padding: const EdgeInsets.only(top:10.0,),
                         child: OutlineButton(
                            color:Colors.red,
                           shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                          child: _uploading  ? SizedBox(
                            width: 20.0, height: 20.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 2.0,
                            ),
                          ) : Text("Upload",style:Theme.of(context).textTheme.button),
                          onPressed:()=>savePhoto(context),
                        ),
                      ),
                    

              ]
            ),
      ),
          
        
        floatingActionButton: file == null ? SizedBox.shrink() : FloatingActionButton(
        backgroundColor:Colors.white,
        onPressed: pickImageFromGallery,
        tooltip: "Add Image",
        child: Icon(Icons.add_a_photo, color:Colors.red),
      )
    );
  }
  }