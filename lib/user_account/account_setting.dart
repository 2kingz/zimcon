import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

class AccountSettingPage extends StatefulWidget {
  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  bool isObsecurePassword = true, isLoading = false;
  String id = "",
      propic = "",
      name = "",
      surname = "",
      phone = "",
      email = "",
      sex = "",
      username = "",
      state = "",
      reg_date = "",
      status = "",
      street = "",
      loc = "",
      vendorEndAgre = "",
      vcode = "",
      city = "";
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();

  TextEditingController oldPass = new TextEditingController();
  TextEditingController newPass = new TextEditingController();
  TextEditingController newPassCon = new TextEditingController();

  TextEditingController house = new TextEditingController();
  TextEditingController location = new TextEditingController();
  TextEditingController cityC = new TextEditingController();

  @override
  void initState() {
    super.initState();
    this.checkVar();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  checkVar() {
    print("Gettting user data");
    fetchUser();
  }

  Future<void> fetchUser() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    setState(() {
      id = data.getString("id")!;
      propic = data.getString("propic")!;
      name = data.getString("name")!;
      surname = data.getString("surname")!;
      phone = data.getString("phone")!;
      email = data.getString("email")!;
      sex = data.getString("sex")!;
      username = data.getString("username")!;
      reg_date = data.getString("reg_date")!;
      state = data.getString("state")!;
      status = data.getString("status")!;
      street = data.getString("street")!;
      loc = data.getString("loc")!;
      city = data.getString("city")!;
      vcode = data.getString("vcode")!;
      vendorEndAgre = data.getString("va")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Account'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
          shadowColor: Colors.transparent),
      body: editAccount(context),
    );
  }

  editAccount(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 5,
                              color: Colors.pink.withOpacity(0.2),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(propic.isNotEmpty
                                  ? propic
                                  : "http://" +
                                      server +
                                      "/ZimCon/UI/images/alias.jpg"))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Colors.pinkAccent),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              headerText("General Information"),
              separator(),
              SizedBox(height: 35),
              Center(
                child: Container(
                  height: 320,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      buildTextField(
                          "First name",
                          name.isEmpty ? "Type your name." : name,
                          false,
                          fname,
                          name.isEmpty ? false : true),
                      buildTextField(
                          "Surname",
                          surname.isEmpty ? "Type your surname." : surname,
                          false,
                          lname,
                          surname.isEmpty ? false : true),
                      buildTextField(
                          "Email",
                          email.isEmpty ? "Type your email." : email,
                          false,
                          emailC,
                          email.isEmpty ? false : true),
                      buildTextField(
                          "Phone",
                          phone.isEmpty ? "Type your phone." : phone,
                          false,
                          phoneC,
                          phone.isEmpty ? false : true),
                    ]),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "UPDATE INFOR",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                        primary: Colors.pink,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  )
                ],
              ),
              separator(),
              headerText("Security Information"),
              separator(),
              SizedBox(height: 35),
              buildTextField("Old Password", "Your current password", true,
                  oldPass, false),
              buildTextField(
                  "New Password", "Type your pass...", true, newPass, false),
              buildTextField("Confirm Password", "Type your pass...", true,
                  newPass, false),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => updateMyPass(),
                    child: Text(
                      "CHANGE PASSWORD",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                        primary: Colors.pink,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  )
                ],
              ),
              separator(),
              headerText("Address"),
              separator(),
              SizedBox(height: 35),
              buildTextField(
                  "House Number",
                  street.isEmpty ? "Type your house number." : street,
                  false,
                  house,
                  street.isEmpty ? false : true),
              buildTextField(
                  "Location",
                  loc.isEmpty ? "Type your location." : loc,
                  false,
                  location,
                  loc.isEmpty ? false : true),
              buildTextField("City", city.isEmpty ? "Type your city." : city,
                  false, cityC, city.isEmpty ? false : true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => updateaddress(),
                    child: Text(
                      "UPDATE ADDRESS",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                        primary: Colors.pink,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  )
                ],
              ),
              separator(),
              headerText("Vendor Associations"),
              separator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  vendorEndAgre.contains("Yes")
                      ? OutlinedButton(
                          onPressed: () => vendorAccountMng(
                              vendorEndAgre.contains("Yes") ? "Yes" : "No"),
                          child: Text("DISABLE VENDOR ACCOUNT",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.grey)),
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        )
                      : ElevatedButton(
                          onPressed: () => vendorAccountMng(
                              vendorEndAgre.contains("Yes") ? "Yes" : "No"),
                          child: Text(
                            "ENABLE VENDOR ACCOUNT",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Colors.pinkAccent.withOpacity(0.7),
                              primary: Colors.pink,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                ],
              ),
            ],
          ),
        ),
      );

  updateMyPass() async {
    try {
      if (newPass.text == newPassCon.text) {
        if (newPass.text.isNotEmpty == false &&
            newPassCon.text.isNotEmpty == false &&
            oldPass.text.isNotEmpty == false) {
          var url = Uri.parse(updatePass);
          var request = await http.post(url, body: {
            "user": id.toString(),
            "old_pass": oldPass.text,
            "new_pass": newPass.text
          });
          if (request.statusCode == 200) {
            var response = jsonDecode(request.body);
            if (response['success'] == "1") {
              SharedPreferences data = await SharedPreferences.getInstance();
              data.reload();
              this.checkVar();
              data.setString("va", response['text'].toString());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response['message'].toString())));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please fill in the blanks.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your new password does not match.")));
      }
    } catch (e) {
      print("Error Caught" + e.toString());
    }
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      TextEditingController controller,
      bool isTextin) {
    if (isTextin == true) {
      controller.text = placeholder;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText:
            isPasswordTextField ? isObsecurePassword : isPasswordTextField,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecurePassword = !isObsecurePassword;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  updateaddress() async {
    finalUpdate();
  }

  finalUpdate() async {
    try {
      var url = Uri.parse(updateAddress);
      var request = await http.post(url, body: {
        "user": id.toString(),
        "str": house.text,
        "loc": location.text,
        "city": cityC.text
      });
      if (request.statusCode == 200) {
        var response = jsonDecode(request.body);
        if (response['success'] == "1") {
          SharedPreferences data = await SharedPreferences.getInstance();
          data.reload();
          this.checkVar();
          data.setString("street", house.text);
          data.setString("loc", location.text);
          data.setString("city", cityC.text);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'].toString())));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'].toString())));
        }
      }
    } catch (e) {
      print("Error Caught" + e.toString());
    }
  }

  vendorAccountMng(var va) async {
    try {
      var url = Uri.parse(updateVendor);
      var request = await http
          .post(url, body: {"user": id.toString(), "cmd": va.toString()});
      if (request.statusCode == 200) {
        var response = jsonDecode(request.body);
        if (response['success'] == "1") {
          SharedPreferences data = await SharedPreferences.getInstance();
          data.reload();
          this.checkVar();
          data.setString("va", response['text'].toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'].toString())));
        }
      }
    } catch (e) {
      print("Error Caught" + e.toString());
    }
  }
}

Widget separator() => Divider(
      color: Colors.pinkAccent.withOpacity(0.2),
      thickness: 1.5,
    );
Widget headerText(String data) => Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.pinkAccent.withOpacity(0.5)),
    );
