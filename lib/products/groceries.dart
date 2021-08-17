import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:zimcon/products/models/Product.dart';
import 'package:zimcon/url/urlData.dart';

import 'screens/home/home_screen.dart';

class Groceries extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _GroceriesState createState() => _GroceriesState();

  void getMyProduct() {
    createState();
  }
}

class _GroceriesState extends State<Groceries> {
  bool isLoading = false;
  List users = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      setProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: productCategories,
      theme: ThemeData(
        textTheme:
            Theme.of(context).textTheme.apply(bodyColor: Colors.pinkAccent),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: getBody(),
    );
  }

  Widget getBody() {
    if (users.contains(null) && users.length < 0 || isLoading) {
      return Center(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nothing to display yet \n Check your internet Connection"
                      .toUpperCase(),
                  style: TextStyle(color: Colors.pink, fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      products.clear();
      try {
        for (var i = 0; i < users.length; i++) {
          final item = users[i];
          products.add(Product(
              id: item["Id"] as String,
              title: item["Name"] as String,
              price: item["Price"] as String,
              size: item["measure_size"] as String,
              description: item["description"],
              image: item["app_img"].toString().isEmpty
                  ? 'product'
                  : server + item["app_img"],
              color: Colors.grey[500]));
        }
      } catch (e) {
        print("ERROR : " + e.toString());
      }
    } // So that it will not duplicate the products

    return HomeScreen();
  }

  getProductColor(String imgLink) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imgLink),
        size: Size(200, 200));
    var color = generator.darkMutedColor == null
        ? generator.darkMutedColor
        : PaletteColor(Colors.grey.shade300, 2);
    return color;
  }

  Future<void> setProduct() async {
    setState(() {
      isLoading = true;
    });
    var mycate = categories[mySelectedIndex];
    var url = Uri.parse(productsList);
    var response = await http.post(url,
        body: {"Category": productCategories, "mycate": mycate.toString()});
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        users = items;
        isLoading = false;
      });
    } else {
      if (products.isNotEmpty) {
        setState(() {
          users = products;
          isLoading = false;
        });
      }
    }
  }
}
