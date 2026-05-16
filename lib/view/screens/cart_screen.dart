import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controller/cart_provider.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return ListTile(
                  title: Text(item.name),
                  trailing: Text('₹${item.price}'),
                );
              },
            ),
          ),
          Text('Total: ₹${cart.total}'),
          ElevatedButton(onPressed: () {}, child: const Text('Checkout'))
        ],
      ),
    );
  }
}