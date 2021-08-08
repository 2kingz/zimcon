import 'package:flutter/material.dart';
import 'package:zimcon/cart/components/myCounterCart.dart';
import 'package:zimcon/cart/models/Cart.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

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
                child: Image.network(cart.img),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "\$${cart.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.pink),
                  children: [
                    TextSpan(
                        text: "x${cart.numOfItem}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.pink),
                        children: [
                          TextSpan(
                            text: "=\$${cart.totalPrice}",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ]),
                  ],
                ),
              )
            ],
          ),
          SizedBox(width: 20),
          MycaounterBtns(cart: cart),
        ],
      ),
    );
  }
}
