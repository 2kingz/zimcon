import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zimcon/adminDashboard/screens/admin.dart';
import 'package:zimcon/size_config.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:zimcon/utility/drawer/navigation_drawer.dart';
import 'utility/griddashboard.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  //geting the nonsese out of this
  var name = "";
  var surname = "";
  var email = '';
  var vendor = "";

  Future getUserInformation() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      name = p.getString('name').toString();
      surname = p.getString('surname').toString();
      email = p.getString('email').toString();
      user = p.getString("id").toString();
      vendor = p.getString("va").toString();
      if (vendor.contains("Yes")) {
        getVendorAccDetails();
      }
    });
    print(name + " " + surname);
  }

  void getVendorAccDetails() async {
    var uri = Uri.parse(getvendoracc);
    var request = await http.post(uri, body: {"user": user.toString()});
    if (request.statusCode == 200) {
      var data = jsonDecode(request.body);
      if (data["success"] == "0") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'].toString())));
      } else {
        setState(() {
          posterId = data['result']['Id'];
          vendorCate = data['result']['Category'];
        });
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig condi = new SizeConfig();
    condi.init(context);
    return Scaffold(
      floatingActionButton: vendor.contains("Yes")
          ? FloatingActionButton(
              elevation: 5,
              backgroundColor: Colors.pink,
              tooltip: "Vendor Dashboard",
              splashColor: Colors.pinkAccent,
              child: Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
              isExtended: true,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Admin()));
              },
            )
          : null,
      drawer: NavigationDrawerWidget(),
      backgroundColor: Color(0xffFFFFFF),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [(new Color(0xffF51167)), (new Color(0xff650328))],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name + ' ' + surname,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.pink[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Dashboard",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xff282828),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  IconButton(
                    alignment: Alignment.topCenter,
                    icon: Image.asset(
                      "images/zimcon.ico",
                      width: 24,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GridDashboard()
          ],
        ),
      ),
    );
  }
}
