import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zimcon/cart/models/Cart.dart';
import 'package:zimcon/checkout/checkout.dart';
import 'package:zimcon/default_button.dart';
import 'package:zimcon/products/constants.dart';
import 'package:zimcon/size_config.dart';
import 'package:zimcon/url/urlData.dart';
import 'components/body.dart';
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
      bottomNavigationBar: myheckoutCard(),
    );
  }

  late Timer timer;
  @override
  void initState() {
    super.initState();
    setState(() {
      getCart();
    });
    //timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getTotalCart());
  }

  Widget getBody() {
    if (items.contains(null) || items.length < 0 || isLoading) {
      return Center(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nothing to display yet".toUpperCase(),
                  style: TextStyle(color: Colors.pink, fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      );
    }
    cartItems.clear(); // So that it will not duplicate the products
    try {
      double sum = 0;
      for (var i = 0; i < items.length; i++) {
        final cartItem = items[i];
        cartItems.add(Cart(
            title: cartItem["Name"],
            numOfItem: cartItem["Qty"],
            id: cartItem["Id"],
            price: cartItem["price"],
            img: cartItem["Image"],
            totalPrice: cartItem["TPrice"]));
        sum += double.parse(cartItem["TPrice"]);
      }
      cartTotal = sum.toStringAsFixed(2);
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
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("ERROR : " + e.toString())));
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

  myheckoutCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    "images/icons/receipt.svg",
                    color: Colors.pink,
                  ),
                ),
                Spacer(),
                Text("Add voucher code"),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$$cartTotal",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmOrderPage()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getTotalCart() async {
    double sum = 0;
    for (int i = 0; i < cartItems.length; i++) {
      sum += double.parse(cartItems[i].totalPrice);
    }
    cartTotal = sum.toStringAsFixed(2);
    print(cartTotal);
  }
}
