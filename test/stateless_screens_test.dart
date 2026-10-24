import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zytranow/view/screens/splash/splash_screen.dart';
import 'package:zytranow/view/screens/auth/login_screen.dart';
import 'package:zytranow/view/screens/auth/otp_screen.dart';
import 'package:zytranow/view/screens/auth/post_otp_loading_screen.dart';
import 'package:zytranow/view/screens/quiz/quiz_screen.dart';
import 'package:zytranow/view/screens/quiz/analyzing_routine_loading_screen.dart';
import 'package:zytranow/view/screens/main_screen.dart';
import 'package:zytranow/view/screens/home/home_screen.dart';
import 'package:zytranow/view/screens/home/widgets/dynamic_category_tabs.dart';
import 'package:zytranow/view/screens/home/widgets/category_tab_bar.dart';
import 'package:zytranow/view/screens/cart_screen.dart';
import 'package:zytranow/view/screens/order_again/order_again_screen.dart';
import 'package:zytranow/view/screens/profile/profile_screen.dart';
import 'package:zytranow/view/screens/search/search_screen.dart';
import 'package:zytranow/view/screens/order_tracking_screen.dart';
import 'package:zytranow/view/screens/categories/categories_screen.dart';
import 'package:zytranow/view/screens/mia/mia_screen.dart';

void main() {
  group('Stateless Pages and Provider Architecture Tests', () {
    test('All pages and navigation views extend StatelessWidget', () {
      expect(const SplashScreen(), isA<StatelessWidget>());
      expect(const LoginScreen(), isA<StatelessWidget>());
      expect(const OtpScreen(), isA<StatelessWidget>());
      expect(const PostOtpLoadingScreen(), isA<StatelessWidget>());
      expect(const QuizScreen(), isA<StatelessWidget>());
      expect(const AnalyzingRoutineLoadingScreen(), isA<StatelessWidget>());
      expect(const MainScreen(), isA<StatelessWidget>());
      expect(const HomeScreen(), isA<StatelessWidget>());
      expect(const DynamicCategoryTabs(isPersonalized: false), isA<StatelessWidget>());
      expect(const CategoryTabBar(), isA<StatelessWidget>());
      expect(const CartScreen(), isA<StatelessWidget>());
      expect(const OrderAgainScreen(), isA<StatelessWidget>());
      expect(const ProfileScreen(), isA<StatelessWidget>());
      expect(const SearchScreen(), isA<StatelessWidget>());
      expect(const OrderTrackingScreen(), isA<StatelessWidget>());
      expect(const CategoriesScreen(), isA<StatelessWidget>());
      expect(const MiaScreen(), isA<StatelessWidget>());
    });
  });
}
