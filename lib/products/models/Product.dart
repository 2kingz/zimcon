import 'package:flutter/material.dart';

class Product {
  final String? id, size, title, description, price;
  String image;
  final Color color;
  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.size,
    required this.color,
  });
}

List<Product> products = [];
