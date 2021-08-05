import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:zimcon/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zimcon/dashboard.dart';
import 'package:zimcon/signup_screen.dart';
import 'package:zimcon/url/urlData.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _error_user = false, _pass_erro = false;

  Future<void> login() async {
    try {
      var url = Uri.parse(loginUrl);
      final response = await http.post(url, body: {
        "username": username.text,
        "pass": password.text,
      });
      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (data['success'] == "4") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Logged in : " + data['message']['Userrname'].toString())));
          //craeting a session
          SharedPreferences p = await SharedPreferences.getInstance();

          p.setString("id", data['message']['Id'].toString());
          p.setString("propic", data['message']['pic'].toString());
          p.setString("name", data['message']['Fname'].toString());
          p.setString("surname", data['message']['Lname'].toString());
          p.setString("phone", data['message']['Phone'].toString());
          p.setString("email", data['message']['email'].toString());
          p.setString("sex", data['message']['gender'].toString());
          p.setString("username", data['message']['Userrname'].toString());
          p.setString(
              "reg_date", data['message']['Date_Registered'].toString());
          p.setString("state", data['message']['State'].toString());
          p.setString("status", data['message']['Status'].toString());
          p.setString("street", data['message']['street'].toString());
          p.setString("loc", data['message']['location'].toString());
          p.setString("city", data['message']['city'].toString());
          p.setString("country", data['message']['county'].toString());
          p.setString("vcode", data['message']['Vendor_code'].toString());
          p.setString("va", data['message']['Vendor_Agreement'].toString());
          p.commit();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Server Response : " + data['message'].toString())));
        }
      } else {
        print("no it did not work");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error : " + e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20)),
                  color: Color(0xffF51167),
                  gradient: LinearGradient(colors: [
                    (new Color(0xffF51167)),
                    (new Color(0xff650328))
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Image.asset("images/logo_light.png"),
                      height: 90,
                      width: 250,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 70),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE))
                  ]),
              alignment: Alignment.center,
              child: TextField(
                controller: username,
                cursorColor: Color(0xffF51167),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color(0xffF51167),
                    ),
                    hintText: "Enter email",
                    errorStyle: TextStyle(
                        color: Colors.redAccent, height: 0, fontSize: 10),
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorText: _error_user ? 'Please enter a Username' : null,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE))
                  ]),
              alignment: Alignment.center,
              child: TextField(
                controller: password,
                obscureText: true,
                cursorColor: Color(0xffF51167),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                      color: Color(0xffF51167),
                    ),
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorStyle: TextStyle(
                        color: Colors.redAccent, height: 0, fontSize: 10),
                    errorText: _pass_erro ? 'Please enter your password' : null,
                    hintText: "Enter your password",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, right: 20),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Text("Forget Password?"),
                onTap: () => {
                  //Open foorget password screen.
                },
              ),
            ),
            TextButton(
              onPressed: () => {
                setState(() {
                  username.text.isEmpty
                      ? _error_user = true
                      : _error_user = false;
                  password.text.isEmpty
                      ? _pass_erro = true
                      : _pass_erro = false;
                  if (_error_user == true || _pass_erro == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Fill the required fields pass")));
                  } else {
                    print("login in");
                    login();
                  }
                })
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                height: 54,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      (new Color(0xffF51167)),
                      (new Color(0xff650328))
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEEE))
                    ]),
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account? "),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()))
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(color: Color(0xffF51167)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
