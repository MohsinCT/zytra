import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/mia_provider.dart';
import 'package:zytranow/mock_data/mock_mia_engine.dart';
import 'package:zytranow/models/mia_models.dart';
import 'package:zytranow/view/screens/mia/mia_screen.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_hybrid_input_bar.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_product_canvas_card.dart';
import 'package:zytranow/view/screens/main_screen.dart';
import 'package:zytranow/controllers/nav_controller.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/order_tracking_provider.dart';
import 'package:zytranow/controllers/order_again_provider.dart';
import 'package:zytranow/controllers/theme_provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/controllers/address_provider.dart';

// Test HTTP override to allow CachedNetworkImage in widget tests without network calls
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _TestHttpOverrides();

  group('MockMiaEngine Tests', () {
    final engine = MockMiaEngine.instance;

    test('getFeaturedLipstickProduct returns valid lipstick state with shades',
        () async {
      final product = await engine.getFeaturedLipstickProduct();

      expect(product.productName, contains('Velvet Whispers'));
      expect(product.brand, equals('Evermi Atelier'));
      expect(product.shades.length, greaterThanOrEqualTo(5));
      expect(product.activeShadeIndex, equals(0));
      expect(product.activeShade.name, equals('Honey Warm'));
      expect(product.activeShade.hexColor, equals('#E28B6A'));
    });

    test('processVoiceCommand switches shades accurately based on voice prompt',
        () async {
      final initialProduct = await engine.getFeaturedLipstickProduct();

      final berryProduct = await engine.processVoiceCommand(
        'Switch to Berry Burst',
        currentProduct: initialProduct,
      );
      expect(berryProduct.activeShadeIndex, equals(1));
      expect(berryProduct.activeShade.name, equals('Berry Burst'));

      final rubyProduct = await engine.processVoiceCommand(
        'Show me Ruby Velvet',
        currentProduct: initialProduct,
      );
      expect(rubyProduct.activeShadeIndex, equals(2));
      expect(rubyProduct.activeShade.name, equals('Ruby Velvet'));

      final honeyProduct = await engine.processVoiceCommand(
        'Show me Honey Shade',
        currentProduct: rubyProduct,
      );
      expect(honeyProduct.activeShadeIndex, equals(0));
      expect(honeyProduct.activeShade.name, equals('Honey Warm'));
    });

    test('parseInstagramUrl extracts INCI ingredients and safety breakdown',
        () async {
      final analysis = await engine.parseInstagramUrl(
        'https://www.instagram.com/reel/C3x9L7vM_evermi/',
      );

      expect(analysis.overallSafetyScore, greaterThan(90.0));
      expect(analysis.authorHandle, equals('@dr.ananya_derm'));
      expect(analysis.ingredients, isNotEmpty);
      expect(
        analysis.ingredients.any((i) => i.name.contains('Hyaluronic')),
        isTrue,
      );
      expect(
        analysis.ingredients.any((i) => i.name.contains('Shea Butter')),
        isTrue,
      );
      expect(analysis.suitabilityTags, isNotEmpty);
    });
  });

  group('MiaProvider State Management Tests', () {
    test('Initializes with default lipstick product and voice mode', () async {
      final provider = MiaProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      expect(provider.mode, equals(MiaInteractionMode.voice));
      expect(provider.activeProduct, isNotNull);
      expect(provider.activeProduct!.activeShade.name, equals('Honey Warm'));
      expect(provider.isListening, isFalse);
    });

    test('Typing in text field immediately switches to Silent Mode', () async {
      final provider = MiaProvider();
      expect(provider.mode, equals(MiaInteractionMode.voice));

      provider.onTextInputChanged('Show me night lipsticks');
      expect(provider.mode, equals(MiaInteractionMode.silent));
    });

    test('switchShade changes active shade index smoothly', () async {
      final provider = MiaProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      provider.switchShade(1);
      expect(provider.activeProduct!.activeShadeIndex, equals(1));
      expect(provider.activeProduct!.activeShade.name, equals('Berry Burst'));

      provider.switchShadeByName('Ruby');
      expect(provider.activeProduct!.activeShade.name, equals('Ruby Velvet'));
    });

    test('Simulate voice trigger starts listening and transcribing', () async {
      final provider = MiaProvider();
      provider.simulateVoiceTrigger('Night-party lipsticks');

      expect(provider.isListening, isTrue);
      expect(provider.isTranscribing, isTrue);

      provider.stopListening();
      expect(provider.isListening, isFalse);
    });
  });

  group('Mia UI Widgets Tests', () {
    testWidgets(
        'MiaScreen renders top bar, dynamic canvas, and hybrid input bar',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 950));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MiaProvider()),
          ],
          child: const MaterialApp(
            home: MiaScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Mia AI'), findsOneWidget);
      expect(find.byType(MiaHybridInputBar), findsOneWidget);
      expect(find.byType(MiaProductCanvasCard), findsOneWidget);
      expect(find.text('Velvet Whispers Luxury Matte'), findsOneWidget);
    });

    testWidgets(
        'Tapping voice trigger chip in hybrid bar initiates listening and updates UI',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 950));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MiaProvider()),
          ],
          child: const MaterialApp(
            home: MiaScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Find quick action pill
      final pillFinder = find.text('Night-party lipsticks');
      expect(pillFinder, findsOneWidget);

      await tester.tap(pillFinder);
      await tester.pump();

      // Listening state active
      expect(find.textContaining('Listening'), findsWidgets);
    });

    testWidgets(
        'MiaScreen opened as standalone route via Navigator.push displays back button and can pop',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 950));

      final key = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MiaProvider()),
          ],
          child: MaterialApp(
            navigatorKey: key,
            home: Scaffold(
              body: Center(
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MiaScreen()),
                      );
                    },
                    child: const Text('Open Mia'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Open Mia'), findsOneWidget);

      // Tap to push MiaScreen
      await tester.tap(find.text('Open Mia'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Now MiaScreen is active
      expect(find.byType(MiaScreen), findsOneWidget);
      final backButton = find.byIcon(Icons.arrow_back_ios_new_rounded);
      expect(backButton, findsOneWidget);

      // Tap back button
      await tester.tap(backButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();

      // Popped back to home
      expect(find.text('Open Mia'), findsOneWidget);
      expect(find.byType(MiaScreen), findsNothing);
    });

    testWidgets(
        'MainScreen renders 3-tab bar (Home, Categories, Order Again) and Mia AI Floating Action Button',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 950));

      final nav = NavProvider();
      nav.updateIndex(2);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: nav),
            ChangeNotifierProvider(create: (_) => MiaProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => OrderAgainProvider()),
            ChangeNotifierProvider(create: (_) => OrderTrackingProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => AddressProvider()),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Bottom bar tabs:
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Order Again'), findsOneWidget);

      // Floating Action Button for Mia AI
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      expect(find.text('Mia AI'), findsOneWidget);

      // Tapping Mia AI Floating Action Button opens MiaScreen as a separate screen
      await tester.tap(fab);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();

      expect(find.byType(MiaScreen), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      // Tapping back returns to MainScreen
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();

      expect(find.byType(MiaScreen), findsNothing);
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        'MiaScreen top bar renders without overflow on narrow 320px, 360px, 375px screens with Navigator.push',
        (tester) async {
      for (final width in [300.0, 320.0, 360.0, 375.0, 390.0, 412.0]) {
        for (final scale in [1.0, 1.25, 1.4]) {
          await tester.binding.setSurfaceSize(Size(width, 700));

          final key = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => MiaProvider()),
              ],
              child: MaterialApp(
                navigatorKey: key,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(scale),
                  ),
                  child: child!,
                ),
                home: Scaffold(
                  body: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MiaScreen()),
                        );
                      },
                      child: const Text('Open'),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pump();
          await tester.tap(find.text('Open'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          expect(
            tester.takeException(),
            isNull,
            reason: 'Overflow occurred at width $width with scale $scale',
          );
        }
      }
    });
  });
}
