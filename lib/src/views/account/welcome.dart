import 'package:flutter/material.dart';
import 'package:popo/src/views/account/login.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.0),
              Image(
                  image: AssetImage("assets/images/badge.png"),
                  height: 380,
                  fit: BoxFit.cover),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 6.0),
                child: Column(
                  children: <Widget>[
                    Text("PFriend",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                          "Police is your friend, our job is to protect you!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ),
                    SizedBox(height: 50.0),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login())),
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text("Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("By continuing you accept our",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    )),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        //  onTap:()=>launchURL("https://cbt-exams-bc05c.web.app/scholar_terms.html"),
                                        child: Text("Term of use ",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Text("and ",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          )),
                                      GestureDetector(
                                        // onTap:()=>launchURL("https://cbt-exams-bc05c.web.app/scholar_privacy.html"),
                                        child: Text("Privacy Policy ",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      )
                                    ])
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
