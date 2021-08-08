import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zimcon/cart/models/Cart.dart';
import 'package:zimcon/url/urlData.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;

  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: getBody(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCart();
    });
  }

  Widget getBody() {
    if (items.contains(null) || items.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Colors.pink,
        backgroundColor: Colors.transparent,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
      ));
    }
    cartItems.clear(); // So that it will not duplicate the products
    try {
      for (var i = 0; i < items.length; i++) {
        final cartItem = items[i];
        cartItems.add(Cart(
            title: cartItem["Name"],
            numOfItem: cartItem["Qty"],
            id: cartItem["Id"],
            price: cartItem["price"],
            img: cartItem["Image"],
            totalPrice: cartItem["TPrice"]));
      }
    } catch (e) {
      print("error : " + e.toString());
    }

    return Body();
  }

  getCart() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse(getMyCartUri);
    var request = await http.post(uri, body: {"user": user.toString()});
    if (request.statusCode == 200) {
      var cart = jsonDecode(request.body);
      if (cart != null) {
        setState(() {
          items = cart;
          isLoading = false;
        });
      } else {
        items = [];
        isLoading = false;
      }
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${items.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
