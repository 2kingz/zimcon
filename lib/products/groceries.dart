import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:zimcon/products/models/Product.dart';
import 'package:zimcon/url/urlData.dart';

import 'screens/home/home_screen.dart';

class Groceries extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _GroceriesState createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  bool isLoading = false;
  List users = [];
  @override
  void initState() {
    // TODO: implement initState
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
    if (users.contains(null) || users.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Colors.pink,
        backgroundColor: Colors.transparent,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
      ));
    }
    products.clear(); // So that it will not duplicate the products
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
                ? 'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/articles/health_tools/portion_sizes_slideshow/getty_rm_photo_of_fish_meal_on_small_plate.jpg'
                : item["app_img"],
            color: Color(0xFFAEAEAE)));
      }
    } catch (e) {
      print("error : " + e.toString());
    }

    return HomeScreen();
  }

  Future<void> setProduct() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(productsList);
    var response = await http.post(url, body: {"Category": productCategories});
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        users = items;
        isLoading = false;
      });
    } else {
      users = [];
      isLoading = false;
    }
  }
}
