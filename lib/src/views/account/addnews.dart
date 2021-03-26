import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:popo/models/news.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  TextEditingController birthDayController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String lat;
  String long;
  String title;
  String news;
  String time;
  String url;
  File file;
  bool isLoading = false;
  bool isUploading = false;

  TextStyle labeStyle = TextStyle(color: Colors.white);

  void uploadImage(context) async {
    setState(() => isUploading = true);
    //Navigator.pop(context);
    //setState(() => isUploading = false);
  }
   String getDate(){
       var formatter = new DateFormat("yyyy-MM-dd");
       String date = formatter.format(DateTime.now());
       return date;
    }
  
Future<String> uploadPhoto() async{
  UploadTask  mStorageUploadTask = FirebaseStorage.instance.ref().child('Images').child("${file.path.toString()}.jpg").putFile(file);
  TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
  String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

  void saveNews()async{
    setState(() => isLoading = true);
    String date =  getDate();
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try{
        String imageUrl = await uploadPhoto();
         News station = new News(title: title, news:news, url:url, time:date, image:imageUrl);
        _database.reference().child("News").push().set(station.toJson());
      } catch (e){
        SnackBar snackBar = SnackBar(content: Text("Error: " + e.toString()));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text("Add News"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100.0),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: createInput() +
                            createButtons() +
                            [
                              SizedBox(
                                height: 30.0,
                              )
                            ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> createInput() {
    return [
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
        style: labeStyle,
        keyboardType: TextInputType.text,
         minLines: 2,
        maxLines:4,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Title',
          labelStyle: labeStyle,
        ),
        validator: (value) {
          return value.isEmpty ? 'Title is required ' : null;
        },
        onSaved: (value) {
          return title = value;
        },
      ),

       TextFormField(
        style: labeStyle,
        keyboardType: TextInputType.text,
         minLines: 2,
        maxLines:4,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Url',
          labelStyle: labeStyle,
        ),
        validator: (value) {
          return value.isEmpty ? 'Title is required ' : null;
        },
        onSaved: (value) {
          return url = value;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        style: labeStyle,
        keyboardType: TextInputType.text,
        minLines: 10,
        maxLines: 10,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          focusedBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          fillColor: Colors.deepPurple.shade100,
          labelText: 'News',
          labelStyle: labeStyle,
        ),
        validator: (value) {
          return value.isEmpty ? 'News is required' : null;
        },
        onSaved: (value) {
          return news = value;
        },
      ),
    ];
  }

  List<Widget> createButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
        ),
        child: GestureDetector(
          onTap: () => saveNews(),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text( "Upload News",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    ];
  }

  void pickImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }
}
