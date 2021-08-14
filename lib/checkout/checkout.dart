import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zimcon/cart/models/Cart.dart';
import 'package:zimcon/url/urlData.dart';

import 'package:http/http.dart' as http;

class ConfirmOrderPage extends StatefulWidget {
  static final String path = "lib/src/pages/ecommerce/confirm_order1.dart";

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  String address = "Micheal, Ballad";
  String phone = "0771668748";
  double total = double.parse(double.parse(cartTotal).toStringAsFixed(2));
  double delivery = 1.20;
  TextEditingController myPhone = new TextEditingController();
  TextEditingController myAddress = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Order",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  int selectedRadio = 0;
  int isSelectphone = 0;
  @override
  void initState() {
    calcMyDelivery();
    super.initState();
    selectedRadio = 0;
    isSelectphone = 0;
  }

  calcMyDelivery() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      address = p.getString("street")! +
          "\n" +
          p.getString("loc")! +
          "\n" +
          p.getString("city")!;
      phone = p.getString("phone")!;
      //double deli = 0.05;
      //double deliver = deli * total;
      //delivery = double.parse(3.toStringAsFixed(2));
    });
  }

  selectedRadioTile(val) {
    setState(() {
      selectedRadio = val;
    });
  }

  selectedPhoneTile(val) {
    setState(() {
      isSelectphone = val;
    });
  }

  Widget _buildBody(BuildContext context) {
    bool iSselected = false;
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Subtotal"),
              Text("\$$total"),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Delivery fee"),
              Text("\$$delivery"),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text("\$${total + delivery}",
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Delivery Address".toUpperCase())),
          Column(
            children: <Widget>[
              RadioListTile(
                selected: selectedRadio == 1 ? true : false,
                value: 1,
                groupValue: selectedRadio,
                title: Text(address),
                onChanged: (val) {
                  selectedRadioTile(val);
                },
              ),
              RadioListTile(
                selected: selectedRadio == 2 ? true : false,
                value: 2,
                groupValue: selectedRadio,
                title: Text("Choose new delivery address"),
                onChanged: (value) {
                  selectedRadioTile(value);
                },
              ),
              if (selectedRadio == 2)
                Container(
                  color: Colors.grey.shade100,
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: myAddress,
                    cursorColor: Colors.pink,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Type new address here...",
                        focusColor: Colors.pink,
                        border: OutlineInputBorder(),
                        labelText: "Address"),
                  ),
                ),
              Container(
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Text("Contact Number".toUpperCase())),
              RadioListTile(
                selected: isSelectphone == 1 ? true : false,
                value: 1,
                groupValue: isSelectphone,
                title: Text(phone),
                onChanged: (dynamic value) {
                  selectedPhoneTile(value);
                },
              ),
              RadioListTile(
                selected: isSelectphone == 2 ? true : false,
                value: 2,
                groupValue: isSelectphone,
                title: Text("Choose new contact number"),
                onChanged: (dynamic value) {
                  selectedPhoneTile(value);
                },
              ),
            ],
          ),
          if (isSelectphone == 2)
            Container(
              color: Colors.grey.shade100,
              padding: EdgeInsets.all(2.0),
              child: TextField(
                controller: myPhone,
                keyboardType: TextInputType.phone,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Type new phone here...",
                    focusColor: Colors.pink,
                    border: OutlineInputBorder(),
                    labelText: "Phone"),
              ),
            ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Payment Option".toUpperCase())),
          RadioListTile(
            groupValue: true,
            value: true,
            title: Text("Cash on Delivery"),
            onChanged: (dynamic value) {},
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => {submitOrder()},
              child: Text(
                "Confirm Order".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  submitOrder() async {
    var url = Uri.parse(subbmitOrdeUri);
    // print("user"+user+
    //   "address"+address+
    //   "phone"+phone+
    //   "shipping"+"Cash on delivery".toString()+
    //   "shipp"+delivery+
    //   "tota"+total.toStringAsFixed(2))
    var response = await http.post(url, body: {
      "user": user,
      "address": address,
      "phone": phone,
      "shipping": "Cash on delivery".toString(),
      "shipp": delivery.toStringAsFixed(2),
      "tota": total.toStringAsFixed(2),
      "zip": "00263",
    });

    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["success"] == "1") {
        cartItems.clear();
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data["message"].toString())));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error : " + response.statusCode.toString())));
    }
  }
}
