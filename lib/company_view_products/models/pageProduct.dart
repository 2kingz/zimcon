import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zimcon/company_view_products/models/network_image.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

class ProducView extends StatefulWidget {
  final List? images;

  final index;

  const ProducView(this.images, this.index);

  @override
  _ProducViewState createState() => _ProducViewState();
}

class _ProducViewState extends State<ProducView> {
  var isLiked, isInCart = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.images![widget.index]['Name']),
      ),
      body: Material(
        child: Container(
          // The blue background emphasizes that it's a new route.
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Hero(
                        tag: "item${widget.index}",
                        child: PNetworkImage(
                            server + widget.images![widget.index]['app_img'],
                            fit: BoxFit.contain))),
                SizedBox(
                  height: 5.0,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.images![widget.index]['Name'],
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      '\$' + widget.images![widget.index]['Price'],
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 40,
                  child: Row(children: <Widget>[
                    Container(
                      // margin: EdgeInsets.only(right: kDefultPaddin),
                      height: 50,
                      width: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        // border: Border.all(
                        //   color: widget.product.color,
                        // ),
                      ),
                      child: IconButton(
                        tooltip: "Like or Dislike the product",
                        icon: SvgPicture.asset(
                          "images/icons/heart.svg",
                          color: isLiked.toString().contains("yes")
                              ? Colors.pink
                              : Colors.black,
                          height: 50,
                          width: double.infinity,
                        ),
                        onPressed: () {
                          likeMyTheProduct(widget.images![widget.index]['Id']);
                        },
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          color: isInCart.toString().contains("yes")
                              ? Colors.pink
                              : Colors.black,
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
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkCart(widget.images![widget.index]['Id']);
    getLike(widget.images![widget.index]['Id']);
  }

  void checkCart(product) async {
    try {
      var url = Uri.parse(checkProductCart);
      var response = await http
          .post(url, body: {"product": product.toString(), "user": user});
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

  addProductToCart() async {
    var url = Uri.parse(addToCart);
    var response = await http.post(url, body: {
      "user": user,
      "product": widget.images![widget.index]['Id'],
      "productName": widget.images![widget.index]['Name'],
      "price": widget.images![widget.index]['Price']
    });
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == 'DELETED' || data['success'] == 'ADDED') {
        checkCart(widget.images![widget.index]['Id']);
      } else if (data['success'] == 'ERR') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'].toString())));
      }
    }
  }

  likeMyTheProduct(preseproduct) async {
    var liker = user;
    var url = Uri.parse(likeItem);
    var response =
        await http.post(url, body: {"product": preseproduct, "liker": liker});
    if (response.statusCode == 200) {
      setState(() {
        getLike(preseproduct);
      });
    }
  }

  getLike(myproduct) async {
    try {
      var url = Uri.parse(checkProductLike);
      var response = await http
          .post(url, body: {"product": myproduct.toString(), "liker": user});
      setState(() {
        print(response.body);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == "1") {
            isLiked = "yes";
          } else {
            isLiked = "no";
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
