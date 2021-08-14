import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zimcon/products/constants.dart';
import 'package:zimcon/products/models/Product.dart';
import 'package:http/http.dart' as http;
import 'package:zimcon/url/urlData.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  var isInCart = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefultPaddin),
      child: Row(
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.only(right: kDefultPaddin),
          //   height: 50,
          //   width: 58,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(18),
          //     border: Border.all(
          //       color: widget.product.color,
          //     ),
          //   ),
          //   child: IconButton(
          //     icon: SvgPicture.asset(
          //       "images/icons/add_to_cart.svg",
          //       color: isInCart.toString().contains("yes")
          //           ? Colors.pink
          //           : widget.product.color,
          //     ),
          //     onPressed: () => addProductToCart(),
          //   ),
          // ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: isInCart.toString().contains("yes")
                    ? Colors.pink
                    : widget.product.color,
                onPressed: () {
                  addProductToCart();
                },
                child: Text(
                  "Add TO Cart".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  addProductToCart() async {
    var url = Uri.parse(addToCart);
    var response = await http.post(url, body: {
      "user": user,
      "product": widget.product.id,
      "productName": widget.product.title,
      "price": widget.product.price
    });
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == 'DELETED' || data['success'] == 'ADDED') {
        checkCart();
      } else if (data['success'] == 'ERR') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'].toString())));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkCart();
  }

  void checkCart() async {
    try {
      var url = Uri.parse(checkProductCart);
      var response = await http.post(url,
          body: {"product": widget.product.id.toString(), "user": user});
      setState(() {
        print(response.body);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == "1") {
            isInCart = "yes";
          } else {
            isInCart = "no";
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
