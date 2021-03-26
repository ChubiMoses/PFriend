import 'dart:async';
import 'package:flutter/material.dart';

class ResetUserPassword extends StatefulWidget {
  @override
  _ResetUserPasswordState createState() => _ResetUserPasswordState();
}

class _ResetUserPasswordState extends State<ResetUserPassword> {
  final _scaffoldKey =  GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final formkey = GlobalKey<FormState>();
  String email;

  resetPassword(){
     final form = _formKey.currentState;
     if(form.validate()){
       form.save();
      sendResetEmail(email);
     }
   }

  Future<void> sendResetEmail(email) async{
     try{
       // FirebaseAuth.instance..sendPasswordResetEmail(email: email);
          SnackBar snackBar = SnackBar(content: Text("A verification email has been sent to your Email Address."));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer(Duration(seconds: 3), (){Navigator.pop(context);});
     }catch(e){
        SnackBar snackBar = SnackBar(content: Text("Message: "+ e.toString()));
        _scaffoldKey.currentState.showSnackBar(snackBar);
       
     }
   
  }
  @override
  Widget build(BuildContext context) {
      return  Scaffold(
        appBar:AppBar(
        title:Text("Reset Password", style:TextStyle(color:Colors.white)),
        backgroundColor:Colors.black,
        centerTitle: true,
      ),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body:  GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
          child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30, top: 0.0, bottom: 20.0),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      
                         Container(
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: true,
                                    style: TextStyle(color: Colors.black),
                                    validator: (val){
                                      if(val.trim().length < 3 || val.isEmpty){
                                        return "Invalid Email Address";
                                      }else{
                                        return null;
                                      }
                                    },
                                    onSaved: (val) => email = val ,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                     // isDense: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Colors.grey)
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      labelText: "Email Address",
                                      labelStyle: TextStyle(fontSize: 16.0),
                                      hintStyle: TextStyle(color:Colors.grey)
                                    ),
                                  ),
                                  ),
                                  SizedBox(height:3.0),
                                  Text("Please enter your Email Address", style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ),
                        

                      GestureDetector(
                        onTap: resetPassword,
                        child: Container(
                          height: 45.0,
                          decoration: BoxDecoration(color:Colors.red, borderRadius: BorderRadius.circular(8.0),),
                          child: Center(
                            child: Text("Reset Password", style: TextStyle( color: Colors.white, fontSize: 16.0, fontFamily: "bariol", fontWeight: FontWeight.w600)),
                          ),
                        ),
                      )
                    ],
                  ),
              ),
        ),
      );
    }
  }
