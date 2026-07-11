import 'package:flutter/foundation.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/services/product_service.dart';
import 'package:zytranow/controllers/category_provider.dart';

class CategoryProductsProvider extends ChangeNotifier {
  String _category = 'Cleaning Essentials';
  List<Product> _products = [];
  final Map<String, int> _quantities = {}; // productId -> qty
  final Set<String> _activeFilters = {};
  bool _loaded = false;

  // New states for stateless screen integration
  int _selectedSidebarIndex = 0;
  List<String> _sidebarItems = [];
  String? _initializedCategoryName;

  String get category => _category;
  List<Product> get products => List.unmodifiable(_products);
  int quantityFor(String productId) => _quantities[productId] ?? 0;
  Set<String> get activeFilters => Set.unmodifiable(_activeFilters);
  bool get loaded => _loaded;

  int get selectedSidebarIndex => _selectedSidebarIndex;
  List<String> get sidebarItems => List.unmodifiable(_sidebarItems);
  String? get initializedCategoryName => _initializedCategoryName;

  void setSelectedSidebarIndex(int index) {
    if (_selectedSidebarIndex != index) {
      _selectedSidebarIndex = index;
      notifyListeners();
    }
  }

  void initCategoryScreen(String categoryName, CategoryProvider categoryProvider) {
    if (_initializedCategoryName == categoryName) return;
    _initializedCategoryName = categoryName;
    _selectedSidebarIndex = 0;

    String normalize(String s) {
      return s.replaceAll(RegExp(r'[^\w\s&]+'), '').trim().toLowerCase();
    }

    final normalizedCategoryName = normalize(categoryName);

    // Find the SubCategory matching the normalized name
    CategoryItem? matchingSubcategory;
    for (var sec in categoryProvider.sections) {
      for (var sub in sec.items) {
        if (normalize(sub.name) == normalizedCategoryName) {
          matchingSubcategory = sub;
          break;
        }
      }
      if (matchingSubcategory != null) break;
    }

    _sidebarItems = [];
    if (matchingSubcategory != null && matchingSubcategory.leafCategories.isNotEmpty) {
      _sidebarItems.addAll(matchingSubcategory.leafCategories);
    } else {
      const customSubcategories = {
        'ethnic wear': ['Kurtas & Kurtis', 'Kurta Sets & Suits', 'Sarees & Blouses', 'Ethnic Bottoms', 'Lehengas & Dupattas'],
        'lip color': ['Bullet Lipsticks', 'Liquid Lipsticks', 'Lip Tints', 'Lip Crayons', 'Matte Lipsticks'],
        'face base': ['Liquid Foundations', 'BB & CC Creams', 'Concealers', 'Compact Powders', 'Loose Powders'],
        'face serums': ['Vitamin C Serums', 'Niacinamide Serums', 'Hyaluronic Serums', 'Salicylic Serums', 'Retinol Serums'],
      };
      final key = normalizedCategoryName;
      final custom = customSubcategories.entries.firstWhere(
        (entry) => key.contains(entry.key) || entry.key.contains(key),
        orElse: () => const MapEntry('', []),
      ).value;
      if (custom.isNotEmpty) {
        _sidebarItems.addAll(custom);
      } else {
        _sidebarItems.add(categoryName);
      }
    }

    // Load initial subcategory products
    if (_sidebarItems.isNotEmpty) {
      loadCategory(_sidebarItems[0]);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadCategory(String categoryName) async {
    _category = categoryName;
    _loaded = false;
    notifyListeners();

    _products = await ProductService.productsForCategory(categoryName);
    _loaded = true;
    notifyListeners();
  }

  void toggleFilter(String f) {
    if (_activeFilters.contains(f)) {
      _activeFilters.remove(f);
    } else {
      _activeFilters.add(f);
    }
    notifyListeners();
  }

  void increment(String productId) {
    _quantities[productId] = (_quantities[productId] ?? 0) + 1;
    notifyListeners();
  }

  void decrement(String productId) {
    final current = (_quantities[productId] ?? 0);
    if (current <= 1) {
      _quantities.remove(productId);
    } else {
      _quantities[productId] = current - 1;
    }
    notifyListeners();
  }
}
