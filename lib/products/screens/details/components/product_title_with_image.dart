import 'package:flutter/material.dart';
import 'package:zimcon/products/models/Product.dart';

import '../../../constants.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Top Trending",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            product.title!,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefultPaddin / 4),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\nPrice\n",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "\$" + product.price.toString(),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: kDefultPaddin),
              Expanded(
                child: Hero(
                  tag: "${product.id}",
                  child: Image.network(
                    product.image!,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
