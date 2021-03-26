import 'package:flutter/material.dart';
import 'package:popo/src/home_tabs.dart';
import 'package:popo/src/views/account/Authentication.dart';
import 'package:popo/src/views/account/Register.dart';
import 'package:popo/src/views/account/addnews.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
final _scaffoldKey =  GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormState>();
String _email = "";
String _password ="";
int visibleCount = 0;
bool obscurePassword = true;
bool isLoading = false;
String loginType = "";
Icon visibilityIcon =Icon(Icons.visibility);
AuthImplementation auth = Auth();
TextStyle labeStyle = TextStyle(color:Colors.white);

  
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

   
 validateAndLogin() async {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
     setState(()=>isLoading = true);
     try{
      await auth.SignIn(_email, _password);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeTabs()));
    }catch(e){
      SnackBar snackBar = SnackBar(content: Text("Error: " + e.message.toString()));
     _scaffoldKey.currentState.showSnackBar(snackBar);
    }
      setState(()=>isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor:Colors.black,
      appBar: AppBar(
        title:Text("Login", style:TextStyle(color:Colors.white)),
        backgroundColor:Colors.black,
        centerTitle: true,
      ),
      body:GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/badge.png"),
              fit: BoxFit.contain
            )
          ),
          child: SingleChildScrollView(
            child: Container(
              color:Colors.black54,
               height:800.0,
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Column(
                   children: <Widget>[
                     SizedBox(height:70.0),
                  Form(
                     key: formKey,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                           children:createInput() + createButtons(),
                       ),
                     ),
                   ),
                  ],
                ),
              )
            ],
          ),
        )
      )
      )
      )
    );
  }

  List<Widget> createInput(){
    return[
       Image(
        image: AssetImage("assets/images/logo3.png"),
        height:40,
        fit:BoxFit.contain
      ),
     
       SizedBox(height: 50.0,),
      TextFormField(
        style:labeStyle,
        decoration: InputDecoration(
          isDense:true,
          contentPadding: EdgeInsets.all(8.0),
          prefixIcon: Icon(Icons.email, size: 18.0, color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0) ),
          focusedBorder: OutlineInputBorder( borderSide: BorderSide(color:Colors.white),),
          fillColor: Colors.deepPurple.shade100,
          labelText: 'Email',
          labelStyle: labeStyle,
          ),
        validator: (value){
          return value.isEmpty ? 'Email is required' : null;
        },
         onSaved:(value){
          return _email = value;
        } ,
        ),
        
       SizedBox(height: 10.0,),

       TextFormField(
         style:labeStyle,
          decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8.0),
          prefixIcon: Icon(Icons.lock, size: 18.0, color: Colors.white),
          suffixIcon: IconButton(icon:visibilityIcon, color: Colors.white, iconSize: 16.0, 
          onPressed:()=>visibilityChange()),
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
          labelText: 'Password',
           labelStyle: labeStyle,
           ),
          obscureText: obscurePassword ? true : false,
          validator: (value){
          return value.isEmpty ? 'Password is required ': null;
        },
        onSaved:(value){
          return _password = value;
        } ,
        )
    ];
   
  }

  
  List<Widget> createButtons(){
      return[
        Padding(
        padding: const EdgeInsets.only(top:30.0),
          child:GestureDetector(
                 onTap:()=>validateAndLogin(),
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
                      ) : Text("Login", style: TextStyle(
                        color:Colors.white, fontWeight: FontWeight.w700, 
                      ),),
                    ),
                  ),
            ),
          ),
        SizedBox(height:10.0),
        Column(
          children: [
            InkWell(
              onTap:(){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddNews()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Text("Forgot password?",
                    style: TextStyle(fontSize:14.0,color:Colors.white)),
                   Text(" reset pasword.", 
                   style: TextStyle(fontSize:14.0,color:Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height:10.0),
            InkWell(
              onTap:()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Register())),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Text("Don't have account? ", 
                 style: TextStyle(fontSize:14.0,color:Colors.white)),
                 Text("Register.", 
                 style: TextStyle(fontSize:14.0, color:Colors.red,fontWeight: FontWeight.bold)),
              ],
             ),
            ),
          ],
        ),
    ];
  }
}