import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:zimcon/products/screens/details/components/add_to_cart.dart';
import 'package:zimcon/url/urlData.dart';
import 'cart_counter.dart';

class CounterWithFavBtn extends StatefulWidget {
  final String? product;

  const CounterWithFavBtn({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _CounterWithFavBtnState createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
  var isLiked = "";
  @override
  void initState() {
    getLike();
    super.initState();
  }

  getLike() async {
    try {
      var url = Uri.parse(checkProductLike);
      var response = await http.post(url,
          body: {"product": widget.product.toString(), "liker": user});
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(),
        InkWell(
          onTap: () {
            return likeMyTheProduct(context, widget.product);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: isLiked.toString().contains("yes")
                  ? Colors.pink
                  : Colors.black,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset("images/icons/heart.svg"),
          ),
        )
      ],
    );
  }

  likeMyTheProduct(BuildContext context, preseproduct) async {
    var liker = user;
    var url = Uri.parse(likeItem);
    var response =
        await http.post(url, body: {"product": preseproduct, "liker": liker});
    if (response.statusCode == 200) {
      setState(() {
        getLike();
      });
    }
  }
}
