import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/services/api_service.dart';
import 'package:zytranow/controllers/category_provider.dart';

class Category {
  final String name;
  final String imageUrl;
  final IconData? icon;

  Category({required this.name, required this.imageUrl, this.icon});
}

class BannerModel {
  final String title;
  final String category;
  final IconData icon;
  final String? backgroundImage;

  BannerModel({
    required this.title,
    required this.category,
    required this.icon,
    this.backgroundImage,
  });
}

class HomeProvider extends ChangeNotifier {
  static const Map<String, String> _categoryImages = {
    'Fashion & Clothing': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=600',
    'Lip Cosmetics': 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
    'Face Cosmetics': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
    'Eye Makeup': 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600',
    'Nail Cosmetics': 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=600',
    'Serums & Toners': 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
    'Sunscreens, Cleansers & Moisturizers': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600',
    'Lip Balms & Masks': 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
    'Facial Kits & Face Masks': 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=600',
    'Hair Color & Touch-up': 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=600',
    'Hair Masks & Serums': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Hair Styling': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Shampoos & Oils': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Bath & Body Tools': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=600',
    'Beauty Accessories': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Hair Brushes & Tools': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Hair & Nail Extensions': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Luxury Beauty': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=600',
    'Perfumes & Gift Sets': 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600',
    "Women's grooming": 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
    "pregnancy time women's essentials": 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=600',
    "women fitness & sports": 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=600',
    'Travel & mobility': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600',
    'books': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=600',
    'Arts & crafts': 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=600',
    "women's footwear": 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=600',
    'bags & wallets': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=600',
    'Hire straighteners & dryers': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'pregnancy test kits': 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=600',
    'wellness sex': 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=600',
    'mehandi items': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
    'spa & beauty accessories': 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
    'Hair Daily Care': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    'Bath Essentials': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=600',
    'Feminine Hygiene': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=600',
    'Body Care': 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
  };

  static const Map<String, String> _categoryTitles = {
    'Fashion & Clothing': 'Elegant styles & daily wear',
    'Lip Cosmetics': 'Vibrant shades and shine for lips',
    'Face Cosmetics': 'Flawless bases and cheek glows',
    'Eye Makeup': 'Define your eyes with drama',
    'Nail Cosmetics': 'Vibrant lacquers and extensions',
    'Serums & Toners': 'Nourishing serums for your skin',
    'Sunscreens, Cleansers & Moisturizers': 'Daily protection and hydration',
    'Lip Balms & Masks': 'Hydration and overnight repair',
    'Facial Kits & Face Masks': 'Home facial and sheet masks',
    'Hair Color & Touch-up': 'Permanent and natural colors',
    'Hair Masks & Serums': 'Deep conditioning and repair',
    'Hair Styling': 'Holds, gels, and curl defining',
    'Shampoos & Oils': 'Daily shampoos and hair growth',
    'Bath & Body Tools': 'Sponges, scrubs, and foot care',
    'Beauty Accessories': 'Makeup brushes and vanity cases',
    'Hair Brushes & Tools': 'Daily detanglers and round brushes',
    'Hair & Nail Extensions': 'Temporary and professional wefts',
    'Luxury Beauty': 'Prestige makeup and elite skincare',
    'Perfumes & Gift Sets': 'Luxurious women fragrances',
    "Women's grooming": 'Facial hair and body shaving',
    "pregnancy time women's essentials": 'Maternity comfort and support',
    "women fitness & sports": 'High-impact apparel and gym wear',
    'Travel & mobility': 'Luggage and travel packaging',
    'books': 'Fiction and growth mindsets',
    'Arts & crafts': 'Painting and needlework kits',
    "women's footwear": 'Casuals, flats, and ethnic juttis',
    'bags & wallets': 'Everyday totes and clutches',
    'Hire straighteners & dryers': 'Straighteners, curl wands, and dryers',
    'pregnancy test kits': 'Rapid detection and digital test kits',
    'wellness sex': 'Intimate lubricants and stimulation',
    'mehandi items': 'Henna cones and Rajasthani powders',
    'spa & beauty accessories': 'Jade rollers and ionic face steamers',
    'Hair Daily Care': 'Leave-in hydration and detangling',
    'Bath Essentials': 'Liquid body washes and bubble baths',
    'Feminine Hygiene': 'Sanitary pads and menstrual cups',
    'Body Care': 'Daily moisturizers and body butters',
  };

  List<Category> allCategories = [];
  List<Category> quickCategories = [];
  List<Product> popularProducts = [];
  List<BannerModel> banners = [];

  List<Category> _unfilteredAllCategories = [];
  List<Category> _unfilteredQuickCategories = [];
  List<BannerModel> _unfilteredBanners = [];
  String activeTab = 'All';
  List<CategorySection> activeSections = [];

  bool isLoading = true;
  int currentBannerIndex = 0;
  Timer? _bannerTimer;

  bool isSensitiveHidden = true; // State for sensitive items toggle

  final PageController bannerController = PageController();

  HomeProvider() {
    fetchHomeData();
  }

  void toggleSensitiveItems(bool value) {
    isSensitiveHidden = value;
    notifyListeners();
  }

  Future<void> fetchHomeData() async {
    // Simulate API call loading state
    isLoading = true;
    notifyListeners();

    final sections = CategoryProvider().sections;

    allCategories = sections.map((sec) {
      final imgUrl = _categoryImages[sec.title] ?? '';
      final icon = sec.items.isNotEmpty ? sec.items.first.icon : Icons.category;
      return Category(name: sec.title, imageUrl: imgUrl, icon: icon);
    }).toList();

    quickCategories = [
      Category(
        name: 'Ethnic Wear',
        imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?q=80&w=300',
        icon: Icons.checkroom,
      ),
      Category(
        name: 'Lip Color',
        imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=300',
        icon: Icons.brush,
      ),
      Category(
        name: 'Face Base',
        imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
        icon: Icons.face,
      ),
      Category(
        name: 'Face Serums',
        imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
        icon: Icons.science,
      ),
      Category(
        name: "Women's Perfumes",
        imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
        icon: Icons.local_florist,
      ),
      Category(
        name: 'Maternity Skincare',
        imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
        icon: Icons.pregnant_woman,
      ),
    ];

    final localPopular = [
      Product(
        id: 'velvet_matte_lipstick',
        name: 'Luxe Velvet Matte Lipstick',
        price: 399,
        imageAsset:
            'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
        unit: '1 Unit',
        deliveryTime: '8 mins',
        rating: 4.8,
        reviews: 452,
        brand: 'MAC',
        category: 'Lip Color',
        images: [
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
        ],
      ),
      Product(
        id: 'niacinamide_serum',
        name: 'Advanced Niacinamide Serum',
        price: 599,
        imageAsset:
            'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
        unit: '30 ml',
        deliveryTime: '9 mins',
        rating: 4.6,
        reviews: 128,
        brand: 'Minimalist',
        category: 'Face Serums',
        images: [
          'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
        ],
      ),
      Product(
        id: 'liquid_foundation',
        name: 'Glow Liquid Foundation',
        price: 799,
        imageAsset:
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
        unit: '50 ml',
        deliveryTime: '10 mins',
        rating: 4.5,
        reviews: 320,
        brand: "L'Oreal",
        category: 'Face Base',
        images: [
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
        ],
      ),
      Product(
        id: 'waterproof_mascara',
        name: 'Colossal Waterproof Mascara',
        price: 349,
        imageAsset:
            'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600',
        unit: '1 Unit',
        deliveryTime: '8 mins',
        rating: 4.7,
        reviews: 180,
        brand: 'Maybelline',
        category: 'Mascaras & Lashes',
        images: [
          'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600',
        ],
      ),
      Product(
        id: 'satin_night_suit',
        name: 'Premium Silk Satin Night Suit',
        price: 1299,
        imageAsset:
            'https://images.unsplash.com/photo-1590736969955-71cb94801758?q=80&w=600',
        unit: '1 Set',
        deliveryTime: '12 mins',
        rating: 4.4,
        reviews: 95,
        brand: 'Zytra',
        category: 'Night Suits',
        images: [
          'https://images.unsplash.com/photo-1590736969955-71cb94801758?q=80&w=600',
        ],
      ),
    ];

    popularProducts = await ApiService.getPopularProducts(localPopular);

    final shuffledSections = List<CategorySection>.from(sections)..shuffle();
    final selectedSections = shuffledSections.take(5).toList();

    banners = selectedSections.map((sec) {
      final imgUrl =
          _categoryImages[sec.title] ??
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600';
      final bannerTitle =
          _categoryTitles[sec.title] ?? 'Get best items in minutes';
      final icon = sec.items.isNotEmpty
          ? sec.items.first.icon
          : Icons.shopping_bag_outlined;
      return BannerModel(
        title: bannerTitle,
        category: sec.title,
        icon: icon,
        backgroundImage: imgUrl,
      );
    }).toList();

    _unfilteredAllCategories = List.from(allCategories);
    _unfilteredQuickCategories = List.from(quickCategories);
    _unfilteredBanners = List.from(banners);

    _filterHomeData();

    isLoading = false;
    notifyListeners();

    _startBannerTimer();
  }

  void setActiveTab(String tab) {
    activeTab = tab;
    _filterHomeData();
    if (bannerController.hasClients) {
      bannerController.jumpToPage(0);
    }
    currentBannerIndex = 0;
    notifyListeners();
  }

  void _filterHomeData() {
    final sections = CategoryProvider().sections;
    CategorySection? getSection(String query) {
      try {
        return sections.firstWhere((sec) => sec.title.toLowerCase().contains(query.toLowerCase()));
      } catch (_) {
        return null;
      }
    }

    if (activeTab == 'All') {
      allCategories = List.from(_unfilteredAllCategories);
      quickCategories = List.from(_unfilteredQuickCategories);
      banners = List.from(_unfilteredBanners);
      activeSections = [];
    } else if (activeTab == 'Homes') {
      quickCategories = [
        Category(
          name: 'Painting Supplies',
          imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=300',
          icon: Icons.palette,
        ),
        Category(
          name: 'Fiction & Literature',
          imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300',
          icon: Icons.book,
        ),
        Category(
          name: 'Luggage & Cases',
          imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=300',
          icon: Icons.luggage,
        ),
        Category(
          name: 'Facial Rolling & Sculpting',
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          icon: Icons.brush,
        ),
        Category(
          name: 'Liquid Body Washes',
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          icon: Icons.bathtub,
        ),
        Category(
          name: 'Loofahs & Sponges',
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          icon: Icons.wash,
        ),
      ];

      allCategories = List.from(quickCategories);

      banners = [
        BannerModel(
          title: "Expressive painting & sketching sets",
          category: "Arts & crafts",
          icon: Icons.palette,
          backgroundImage: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=600',
        ),
        BannerModel(
          title: "Scented candles & spa collection",
          category: "spa & beauty accessories",
          icon: Icons.spa,
          backgroundImage: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=600',
        ),
      ];

      activeSections = [
        getSection('Bath Essentials') ?? sections[0],
        getSection('Bath & Body Tools') ?? sections[1],
        getSection('spa & beauty accessories') ?? sections[2],
      ].whereType<CategorySection>().toList();
    } else if (activeTab == 'Women') {
      quickCategories = [
        Category(
          name: 'Lip Color',
          imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=300',
          icon: Icons.brush,
        ),
        Category(
          name: 'Face Base',
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          icon: Icons.face,
        ),
        Category(
          name: 'Nail Lacquers',
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          icon: Icons.palette,
        ),
        Category(
          name: "Women's Perfumes",
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          icon: Icons.local_florist,
        ),
      ];

      allCategories = List.from(quickCategories);

      banners = [
        BannerModel(
          title: "Stunning Lip Colors & Glosses",
          category: "Lip Cosmetics",
          icon: Icons.brush,
          backgroundImage: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
        ),
      ];

      activeSections = [
        sections.firstWhere((sec) => sec.title == 'Lip Cosmetics'),
        sections.firstWhere((sec) => sec.title == 'Face Cosmetics'),
        sections.firstWhere((sec) => sec.title == 'Eye Makeup'),
      ];
    } else if (activeTab == 'Pregnant & Kids') {
      quickCategories = [
        Category(
          name: 'Maternity Skincare',
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          icon: Icons.pregnant_woman,
        ),
        Category(
          name: 'Maternity Support',
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          icon: Icons.support,
        ),
        Category(
          name: 'Rapid Pregnancy Detection',
          imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=300',
          icon: Icons.favorite,
        ),
      ];

      allCategories = List.from(quickCategories);

      banners = [
        BannerModel(
          title: "Safe Maternity Care & Comfort",
          category: "pregnancy time women's essentials",
          icon: Icons.pregnant_woman,
          backgroundImage: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=600',
        ),
      ];

      activeSections = [
        sections.firstWhere((sec) => sec.title == "pregnancy time women's essentials"),
        sections.firstWhere((sec) => sec.title == 'pregnancy test kits'),
      ];
    }
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (banners.isNotEmpty && bannerController.hasClients) {
        currentBannerIndex = (currentBannerIndex + 1) % banners.length;
        bannerController.animateToPage(
          currentBannerIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    });
  }

  void setBannerIndex(int index) {
    currentBannerIndex = index;
    notifyListeners();
    // Restart timer on manual swipe to avoid instant auto-scroll
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    bannerController.dispose();
    super.dispose();
  }
}
