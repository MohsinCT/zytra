import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controller/nav_controller.dart';
import 'package:zytranow/view/screens/cart_screen.dart';
import 'package:zytranow/view/screens/categories_screen.dart';
import 'package:zytranow/view/screens/home_screen_s.dart';
import 'package:zytranow/view/screens/order_screen.dart';
import 'package:zytranow/view/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // Pre-define the screens here as constants so they aren't rebuilt unnecessarily.
  // When you connect APIs in the individual screens, they will use their respective
  // providers (e.g., HomeProvider, CategoryProvider) to fetch data asynchronously.
  static const List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch the NavProvider for changes to the selected tab index
    final navProvider = context.watch<NavProvider>();

    return Scaffold(
      body: _screens[navProvider.index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.index,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensure all items stay visible
        onTap: (i) {
          // Update the index in the provider
          context.read<NavProvider>().updateIndex(i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
