import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:zimcon/cart/cart_screen.dart';
import 'package:zimcon/cart/models/Cart.dart';
import 'package:zimcon/products/constants.dart';
import 'package:zimcon/url/urlData.dart';
import '../../../size_config.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  void initState() {
    super.initState();
    setQty();
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
              (numOfItems * double.parse(widget.cart.price)).toStringAsFixed(2);
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

  int numOfItems = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(widget.cart.img),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.title.characters.length > 10
                    ? widget.cart.title.substring(0, 10) + "..."
                    : widget.cart.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Row(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefultPaddin / 6),
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
              ),
            ],
          ),
          SizedBox(width: 10),
          Text.rich(
            TextSpan(
              text: "\$${widget.cart.price}",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.pink),
              children: [
                TextSpan(
                    text: "x${widget.cart.numOfItem}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.pink),
                    children: [
                      TextSpan(
                        text: "=\$${widget.cart.totalPrice}",
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }
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
