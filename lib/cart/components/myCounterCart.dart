import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:zimcon/cart/models/Cart.dart';
import 'package:zimcon/products/constants.dart';
import 'package:zimcon/url/urlData.dart';

class MycaounterBtns extends StatefulWidget {
  final Cart cart;

  const MycaounterBtns({Key? key, required this.cart}) : super(key: key);

  @override
  _MycaounterBtnsState createState() => _MycaounterBtnsState();
}

class _MycaounterBtnsState extends State<MycaounterBtns> {
  int numOfItems = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setQty();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                numOfItems--;
                widget.cart.numOfItem = numOfItems.toString();
                setCartQty("dec");
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefultPaddin / 6),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                numOfItems++;
                widget.cart.numOfItem = numOfItems.toString();
                setCartQty("inc");
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({required IconData icon, press}) {
    return SizedBox(
        width: 25,
        height: 25,
        child: ElevatedButton(
          onPressed: press,
          child: Icon(icon),
          style: OutlinedButton.styleFrom(
              enableFeedback: true,
              backgroundColor: Colors.white,
              primary: Colors.pink,
              padding: EdgeInsets.symmetric(horizontal: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ));
  }

  void setCartQty(cmd) async {
    var url = Uri.parse(uriEdit);
    var resquest = await http.post(url, body: {
      "cmd": cmd,
      "price": widget.cart.price,
      "cartId": widget.cart.id,
      "User": user,
    });

    if (resquest.statusCode == 200) {
      print(resquest.body);
      var data = jsonDecode(resquest.body);
      if (data['success'] == "1") {
        setState(() {
          cartTotal = data['Total'];
          widget.cart.totalPrice =
              (numOfItems * double.parse(widget.cart.price)).toString();
          setQty();
        });
      }
    } else {}
  }

  void setQty() {
    setState(() {
      String mystr = widget.cart.numOfItem;
      numOfItems = int.tryParse(mystr)!;
    });
  }
}
