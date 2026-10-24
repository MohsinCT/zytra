import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/auth_provider.dart';
import 'package:zytranow/controllers/carousel_provider.dart';
import 'package:zytranow/view/screens/auth/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders carousel, logo, headline, inputs, and buttons',
      (WidgetTester tester) async {
    final authProvider = AuthProvider();
    final carouselProvider = CarouselProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<CarouselProvider>.value(value: carouselProvider),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Initial pump
    await tester.pump();

    // Verify CachedNetworkImage is in the tree
    expect(find.byType(CachedNetworkImage), findsWidgets);

    // Verify PageView is present
    expect(find.byType(PageView), findsOneWidget);

    // Verify Skip button is present
    expect(find.text('Skip'), findsOneWidget);

    // Verify headline and subtitle
    expect(
      find.text('Everything she needs\ndelivered in Minutes'),
      findsOneWidget,
    );
    expect(find.text('Log in or sign up'), findsOneWidget);

    // Verify phone input prefix and hint
    expect(find.text('+91'), findsOneWidget);
    expect(find.text('Enter mobile number'), findsOneWidget);

    // Verify CTA Continue button
    expect(find.text('Continue'), findsOneWidget);

    // Clean up
    authProvider.dispose();
    carouselProvider.dispose();
  });
}
