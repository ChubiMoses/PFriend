import 'dart:async';
import 'package:flutter/material.dart';
import 'package:popo/src/views/home_view.dart';
import 'package:popo/src/views/account/Authentication.dart';
import 'package:popo/src/views/account/welcome.dart';

class Mapping extends StatefulWidget {
  @override
  _MappingState createState() => _MappingState();
}

enum AuthStatus{
  notSignedIn, signedIn, isLoading, 
}

class _MappingState extends State<Mapping> {
  AuthStatus authStatus = AuthStatus.isLoading;
  int isDynamicLink = 0;
  StreamSubscription _intentDataStreamSubscription;
  String inviteId;
  AuthImplementation auth = Auth();
 

  @override
  void initState(){
    super.initState();
     auth.isSignedIn().then((user){
      setState(()=>authStatus = user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn);
     });
  }

 

  @override 
  Widget build(BuildContext context) {
    //display view based on user credential
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return new Welcome();
      case AuthStatus.isLoading:
        return new Welcome();
        break;
      case AuthStatus.signedIn:
        return new HomeView();
        break;
    }
    return null;
  }

 
   @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}