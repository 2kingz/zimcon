import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zimcon/products/groceries.dart';
import 'package:zimcon/url/urlData.dart';

class GridDashboard extends StatefulWidget {
  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Items item1 = new Items(
      title: "Groceries",
      subtitle: "Food Out, Supermarkets, e.t.c",
      event: "4 Categories",
      img: "images/groceries.png",
      onPress: Groceries(),
      cateTitle: "Food");

  Items item2 = new Items(
      title: "Fashion",
      subtitle: "Tailors, Stores",
      event: "2 Categories",
      img: "images/fashion.png",
      onPress: Groceries(),
      cateTitle: "Fashion");

  Items item3 = new Items(
      title: "Hardware",
      subtitle: "Services, Furniture e.t.c",
      event: "3 Categories",
      img: "images/hardware.png",
      onPress: Groceries(),
      cateTitle: "Hardware");

  Items item4 = new Items(
      title: "Lifestyle",
      subtitle: "Hotel, Lodges e.t.c",
      event: "",
      img: "images/lifestyle.png",
      onPress: null,
      cateTitle: "Hotel");

  Items item5 = new Items(
      title: "Cars",
      subtitle: "Mota chete, chete",
      event: "4 Items",
      img: "images/cars.png",
      onPress: null,
      cateTitle: "Cars");

  Items item6 = new Items(
      title: "Ranto",
      subtitle: "Rental houses",
      event: "2 Items",
      img: "images/favicon.ico",
      onPress: null,
      cateTitle: "Rent");

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xff690c2f;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: () {
                productCategories = data.cateTitle;
                print("Data Stored" + productCategories.toString());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => data.onPress));
              },
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 5),
                        blurRadius: 10,
                        color: Colors.pinkAccent,
                      )
                    ],
                    color: Color(color),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 50,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.event,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  var onPress;
  String cateTitle;
  Items(
      {required this.title,
      required this.subtitle,
      required this.event,
      required this.img,
      required this.onPress,
      required this.cateTitle});
}
