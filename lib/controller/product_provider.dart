import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class ProductProvider extends ChangeNotifier {
  final List<Product> products = [
    Product(name: 'Whisper XL', price: 45),
    Product(name: 'Face Wash', price: 199),
    Product(name: 'Lip Balm', price: 99),
  ];
}