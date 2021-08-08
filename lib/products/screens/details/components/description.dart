import 'package:flutter/material.dart';
import 'package:zimcon/products/constants.dart';
import 'package:zimcon/products/models/Product.dart';

class Description extends StatelessWidget {
  const Description({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefultPaddin / 4),
      child: Text(
        product.description!,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
