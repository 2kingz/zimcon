import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:zimcon/url/urlData.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => InitState();
}

class InitState extends State<SignUpScreen> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController fpassword = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();
  bool isname = false, isPhone = false, isusername = false, ispass = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  Future<void> doRegister() async {
    EasyLoading.show(status: "Please wait...");
    var url = Uri.parse(register);
    print(url);
    print(fpassword.text.toString() + cpassword.text.toString());
    if (fpassword.text.toString() == cpassword.text.toString()) {
      final response = await http.post(url, body: {
        "name": name.text,
        "email": email.text,
        "phone": phone.text,
        "username": username.text,
        "fpassword": fpassword.text
      });
      if (response.statusCode == 200) {
        print(response.body.toString());
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Response : " + data['message'].toString())));
        if (data['success'].toString() == "1") {
          EasyLoading.showToast("Gongrats you're now a member");
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Error Response code " + response.statusCode.toString())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("password do not match...")));
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(20)),
                    gradient: LinearGradient(
                        colors: [
                          (new Color(0xffF51167)),
                          (new Color(0xff650328))
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Image.asset("images/logo.png"),
                        height: 50,
                        width: 250,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20, top: 20),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: isname ? Colors.redAccent : Color(0xffEEEEEE))
                    ]),
                alignment: Alignment.center,
                child: TextField(
                  controller: name,
                  cursorColor: Color(0xffF51167),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Color(0xffF51167),
                      ),
                      errorStyle: TextStyle(
                          color: Colors.redAccent, height: 0, fontSize: 10),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      errorText:
                          isname ? 'Please enter your name & surname' : null,
                      hintText: "Enter your name here.",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  cursorColor: Color(0xffF51167),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Color(0xffF51167),
                      ),
                      hintText: "Enter email",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: isPhone ? Colors.redAccent : Color(0xffEEEEEE))
                    ]),
                alignment: Alignment.center,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  cursorColor: Color(0xffF51167),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: Color(0xffF51167),
                      ),
                      hintText: "Phone e.g. '+263770000000'",
                      errorStyle: TextStyle(
                          color: Colors.redAccent, height: 0, fontSize: 10),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      errorText:
                          isPhone ? 'Please enter your phone number' : null,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color:
                              isusername ? Colors.redAccent : Color(0xffEEEEEE))
                    ]),
                alignment: Alignment.center,
                child: TextField(
                  controller: username,
                  cursorColor: Color(0xffF51167),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.verified_user,
                        color: Color(0xffF51167),
                      ),
                      hintText: "Enter your username",
                      errorStyle: TextStyle(
                          color: Colors.redAccent, height: 0, fontSize: 10),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      errorText: isusername ? 'Please enter Username' : null,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: ispass ? Colors.redAccent : Color(0xffEEEEEE))
                    ]),
                alignment: Alignment.center,
                child: TextField(
                  obscureText: true,
                  controller: fpassword,
                  cursorColor: Color(0xffF51167),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Color(0xffF51167),
                      ),
                      hintText: "Enter password",
                      errorStyle: TextStyle(
                          color: Colors.redAccent, height: 0, fontSize: 10),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      errorText: ispass ? 'Please enter password' : null,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
                  obscureText: true,
                  controller: cpassword,
                  cursorColor: Color(0xffF51167),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Color(0xffF51167),
                      ),
                      hintText: "Retype your password",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You are agree with "),
                    GestureDetector(
                      onTap: () => {Navigator.pop(context)},
                      child: Text(
                        "Terms and Conditions",
                        style: TextStyle(color: Color(0xffF51167)),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => {
                  setState(() {
                    name.text.isEmpty ? isname = true : isname = false;
                    phone.text.isEmpty ? isPhone = true : isPhone = false;
                    username.text.isEmpty
                        ? isusername = true
                        : isusername = false;
                    fpassword.text.isEmpty ? ispass = true : ispass = false;
                    if (isname == true ||
                        isPhone == true ||
                        isusername == true ||
                        ispass == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please fill the blank fields.")));
                    } else {
                      doRegister();
                    }
                  })
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 54,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            (new Color(0xffF51167)),
                            (new Color(0xff650328))
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEEE))
                      ]),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member? "),
                    GestureDetector(
                      onTap: () => {Navigator.pop(context)},
                      child: Text(
                        "Login Now",
                        style: TextStyle(color: Color(0xffF51167)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
