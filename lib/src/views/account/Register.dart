import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:popo/models/user.dart';
import 'package:popo/src/home_tabs.dart';
import 'package:popo/src/views/account/Authentication.dart';
import 'package:popo/src/views/account/addnew.dart';

class Register extends StatefulWidget {
  final String inviteId;
  Register({this.inviteId});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
FirebaseDatabase _database = FirebaseDatabase.instance;
TextEditingController birthDayController = TextEditingController();
final _scaffoldKey =  GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormState>();
String email = "";
String password ="";
String username ="";
String gender ="";
String phone ="";
double lat;
double long;
int visibleCount = 0;
bool obscurePassword = true;
bool isLoading = false;
Icon visibilityIcon =Icon(Icons.visibility);
AuthImplementation auth = Auth();
TextStyle labeStyle = TextStyle(color:Colors.white);
FirebaseDatabase database;
    
Future<Position> getLocation() async {
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
    
 @override
 void initState() { 
   super.initState();
   database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
 }
  Future saveUser(userId) async {
   Position position = await getLocation();
    User user = new User(name: username,  gender:gender, email:email, phone:phone, lat: position.latitude, long: position.latitude,  image:"");
      _database.reference().child("Users").child(userId).set(user.toJson());
    }

   void visibilityChange(){
      visibleCount++;
    if(visibleCount == 1){
     setState(() {
      obscurePassword =  false;
      visibilityIcon = Icon(Icons.visibility_off);
    });
    }else{
     setState(() {
      obscurePassword =  true;
      visibilityIcon = Icon(Icons.visibility);
      visibleCount = 0;
    });
    }
   }

  validateAndSave() async{
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
       setState(()=>isLoading = true);
         try{
            String userId = await auth.SignUp(email, password);
            await saveUser(userId);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeTabs()));
          }catch(e){
            SnackBar snackBar = SnackBar(content: Text("Error: " + e.message.toString()));
          _scaffoldKey.currentState.showSnackBar(snackBar);
          }
       }
      setState(()=>isLoading = false);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
       backgroundColor:Colors.black87,
      appBar: AppBar(
        backgroundColor:Colors.black87,
        title:Text("Register"),
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
        TextFormField(
         style:labeStyle,
         keyboardType: TextInputType.text,
         textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white), ),
          labelText: 'Full name',
           labelStyle: labeStyle,
          ),
          
          validator: (value){
          return value.isEmpty ? 'Full name is required ': null;
        },
        onSaved:(value){
          return username = value;
        } ,
        ),
       SizedBox(height: 20.0,),
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
         SizedBox(height: 20.0,),
         TextFormField(
           style:labeStyle,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
            isDense: true,
            suffixIcon: IconButton(icon:visibilityIcon, color: Colors.white, iconSize: 16.0, onPressed:()=>visibilityChange()),
            border: OutlineInputBorder(	borderRadius: BorderRadius.circular(5.0)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
            labelStyle: labeStyle,
            labelText: 'Password',
             ),
            obscureText: obscurePassword ? true : false,
            validator: (value){
            return value.isEmpty ? 'Password is required ': null;
          },
          onSaved:(value){
            return password = value;
          } ,
          ),
          Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Male", style: TextStyle(fontSize: 14.0,color:Colors.white)),
                Radio(
                  value: "Male", 
                  groupValue: gender,
                  onChanged:(val){
                    setState(() {
                        gender = val;
                    });
                  }
                  )
              ],
            ),

        Row(
          children: <Widget>[
            Text("Female", style: TextStyle(fontSize: 14.0, color:Colors.white),),
            Radio(
              value: "Female", 
              groupValue: gender,
              onChanged:(val){
                setState(() {
                  gender = val;
                });
              }
              )
          ],
        ),
       ]
      )
    ];
   }
  

  
  List<Widget> createButtons(){
      return[
         Padding(
        padding: const EdgeInsets.only(top:10.0,),
          child:GestureDetector(
                  onTap:()=>validateAndSave(),
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
                      ) : Text("Register", style: TextStyle(
                        color:Colors.white, fontWeight: FontWeight.w700, 
                      ),),
                    ),
                  ),
            ),
          ),
         TextButton(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Text("Already have account? ", style: TextStyle(fontSize:14.0, color: Colors.white,)),
               Text("login.", style: TextStyle(fontSize:14.0,color:Colors.red,)),
            ],
          ),
          onPressed:()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddStation()))   
      ),
      SizedBox(height:10.0),
    ];
   }
  }