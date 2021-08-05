import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zimcon/dashboard.dart';
import 'package:zimcon/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
    //check__login_state();
  }

  startTime() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var email = p.getString("id");
    print(email);
    var duration = Duration(seconds: 2);
    if (email == null || email == "") {
      return new Timer(duration, loginRoute);
    } else {
      return new Timer(duration, dashboardRoute);
    }
  }

  dashboardRoute() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  loginRoute() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: new Color(0xffF51167),
                  gradient: LinearGradient(colors: [
                    (new Color(0xffF51167)),
                    (new Color(0xff650328))
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
          Center(
            child: Container(
              child: Image.asset("images/logo_light.png"),
            ),
          )
        ],
      ),
    );
  }
}
