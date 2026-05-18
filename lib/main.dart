import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zytranow/controllers/nav_controller.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/controllers/order_again_provider.dart';
import 'package:zytranow/controllers/auth_provider.dart';
import 'package:zytranow/controllers/carousel_provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/controllers/category_products_provider.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/view/screens/splash/splash_screen.dart';
import 'package:zytranow/view/screens/categories/category_products_screen.dart';

// App entry contract (small):
// - Input: platform device dimensions, OS text scale.
// - Output: MaterialApp with providers and responsive text scaling.
// - Error modes: missing providers -> app still launches; scaling clamped to safe range.

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: _appProviders,
      child: const ZytraApp(),
    ),
  );
}

// Centralized providers list to keep main tidy and make it easy to add/remove providers.
final List<SingleChildWidget> _appProviders = [
  ChangeNotifierProvider(create: (_) => NavProvider()),
  ChangeNotifierProvider(create: (_) => HomeProvider()),
  ChangeNotifierProvider(create: (_) => CategoryProvider()),
  ChangeNotifierProvider(create: (_) => CategoryProductsProvider()),
  ChangeNotifierProvider(create: (_) => CartProvider()),
  ChangeNotifierProvider(create: (_) => OrderAgainProvider()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => CarouselProvider()),
  ChangeNotifierProvider(create: (_) => LocationProvider()),
];

class ZytraApp extends StatelessWidget {
  const ZytraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Light grey
      primaryColor: const Color(0xFFFF2D6F), // Pink
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
        secondary: const Color(0xFFFF2D6F),
      ),
      fontFamily: 'Inter',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    // Use MaterialApp.builder to inject a responsive MediaQuery (textScaleFactor)
    // so that text and small UI elements scale reasonably across phones/tablets/web.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      // The builder receives the child (Navigator / routes). We wrap it with LayoutBuilder
      // to decide a sane textScaleFactor based on available width.
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // Simple breakpoint-based scale — tuned for typical mobile widths.
            double textScale;
            if (width <= 320) {
              textScale = 0.85; // very small phones
            } else if (width <= 375) {
              textScale = 0.95; // small phones
            } else if (width <= 600) {
              textScale = 1.0; // typical phones
            } else if (width <= 900) {
              textScale = 1.1; // small tablets / large phones
            } else {
              textScale = 1.2; // tablets / desktop
            }

            // Also respect user accessibility text scale but clamp it to a reasonable range
            // to keep UI from breaking; this combines systemTextScaleFactor and our calculated scale.
            final systemScale = MediaQuery.of(context).textScaleFactor;
            final combined = (systemScale * textScale).clamp(0.8, 1.4).toDouble();

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: combined),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
      home: const SplashScreen(),
      // optional named route for categories
      routes: {
        '/category': (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as String? ?? 'Cleaning Essentials';
          return CategoryProductsScreen(categoryName: args);
        }
      },
    );
  }
}
