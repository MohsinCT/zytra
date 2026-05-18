import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> products = [
    Product(
      id: 'whisper_xl',
      name: 'Whisper XL',
      imageAsset: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
      unit: '1 Pack',
      price: 45,
      deliveryTime: '10 mins',
    ),
    Product(
      id: 'face_wash',
      name: 'Face Wash',
      imageAsset: 'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=600',
      unit: '100 ml',
      price: 199,
      deliveryTime: '10 mins',
    ),
    Product(
      id: 'lip_balm',
      name: 'Lip Balm',
      imageAsset: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?q=80&w=600',
      unit: '1 Unit',
      price: 99,
      deliveryTime: '10 mins',
    ),
  ];
}