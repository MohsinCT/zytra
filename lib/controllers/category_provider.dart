import 'package:flutter/material.dart';

class CategoryItem {
  final String name; // Subcategory name
  final IconData icon;
  final List<String> leafCategories;
  final String imageUrl;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.leafCategories,
    this.imageUrl = '',
  });
}

class CategorySection {
  final String title; // Main category name
  final List<CategoryItem> items; // Subcategories

  CategorySection({required this.title, required this.items});
}

class CategoryProvider extends ChangeNotifier {
  final List<CategorySection> sections = [
    CategorySection(
      title: 'Fashion & Clothing',
      items: [
        CategoryItem(
          name: 'Ethnic Wear',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?q=80&w=300',
          leafCategories: ['Kurtas & Kurtis', 'Kurta Sets & Suits', 'Sarees & Blouses', 'Ethnic Bottoms', 'Lehengas & Dupattas'],
        ),
        CategoryItem(
          name: 'Western Wear',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=300',
          leafCategories: ['Tops & T-Shirts', 'Dresses & Jumpsuits', 'Jeans & Trousers', 'Shirts & Blouses', 'Skirts & Shorts'],
        ),
        CategoryItem(
          name: 'Sleep & Loungewear',
          icon: Icons.hotel,
          imageUrl: 'https://images.unsplash.com/photo-1590736969955-71cb94801758?q=80&w=300',
          leafCategories: ['Night Suits', 'Nighties & Gowns', 'Pyjamas & Pants', 'Lounge Tees', 'Robes'],
        ),
        CategoryItem(
          name: 'Lingerie & Innerwear',
          icon: Icons.pregnant_woman,
          imageUrl: 'https://images.unsplash.com/photo-1579619173026-cd349788fbc8?q=80&w=300',
          leafCategories: ['Bras', 'Briefs & Panties', 'Camisoles & Slips', 'Shapewear', 'Boxers & Trunks'],
        ),
        CategoryItem(
          name: 'Winter Wear',
          icon: Icons.ac_unit,
          imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=300',
          leafCategories: ['Jackets & Coats', 'Sweaters & Cardigans', 'Sweatshirts', 'Shrugs', 'Thermal Wear'],
        ),
      ],
    ),
    CategorySection(
      title: 'Lip Cosmetics',
      items: [
        CategoryItem(
          name: 'Lip Color',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=300',
          leafCategories: ['Bullet Lipsticks', 'Liquid Lipsticks', 'Lip Tints', 'Lip Crayons', 'Matte Lipsticks'],
        ),
        CategoryItem(
          name: 'Lip Shine',
          icon: Icons.face,
          imageUrl: 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=300',
          leafCategories: ['Lip Glosses', 'Plumping Gloss', 'Lip Oils', 'Clear Gloss', 'Shimmer Gloss'],
        ),
        CategoryItem(
          name: 'Lip Definition',
          icon: Icons.edit,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Matte Liners', 'Automatic Liners', 'Waterproof Liners', 'Lip Primers', 'Defining Crayons'],
        ),
        CategoryItem(
          name: 'Lip Care & Prep',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Lip Scrubs', 'Daytime Balms', 'Overnight Masks', 'Lip Plumpers', 'Tinted Oils'],
        ),
        CategoryItem(
          name: 'Lip Palettes & Kits',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300',
          leafCategories: ['Lipstick Palettes', 'Mini Lipstick Kits', 'Lip Gloss Trios', 'Lip Combo Packs', 'Multi-Shade Palettes'],
        ),
      ],
    ),
    CategorySection(
      title: 'Face Cosmetics',
      items: [
        CategoryItem(
          name: 'Face Base',
          icon: Icons.face,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Liquid Foundations', 'BB & CC Creams', 'Concealers', 'Compact Powders', 'Loose Powders'],
        ),
        CategoryItem(
          name: 'Cheek & Glow',
          icon: Icons.blur_on,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Powder Blushes', 'Liquid Blushes', 'Highlighters', 'Contours & Bronzers', 'Cheek Tints'],
        ),
        CategoryItem(
          name: 'Primers & Fixers',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=300',
          leafCategories: ['Mattifying Primers', 'Hydrating Primers', 'Dewy Setting Sprays', 'Matte Finishing Sprays', 'Color Correctors'],
        ),
        CategoryItem(
          name: 'Makeup Removers',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=300',
          leafCategories: ['Micellar Water', 'Cleansing Balms', 'Bi-Phase Removers', 'Makeup Wipes', 'Oil Cleansers'],
        ),
        CategoryItem(
          name: 'Contour & Sculpt Kits',
          icon: Icons.grid_on,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Contour Palettes', 'Highlight Palettes', 'All-in-One Palettes', 'Color Correcting Kits', 'Strobing Liquids'],
        ),
      ],
    ),
    CategorySection(
      title: 'Eye Makeup',
      items: [
        CategoryItem(
          name: 'Liners & Kajal',
          icon: Icons.remove_red_eye,
          imageUrl: 'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=300',
          leafCategories: ['Black Kajal', 'Colored Kajal', 'Liquid Eyeliners', 'Gel Eyeliners', 'Pen & Sketch Liners'],
        ),
        CategoryItem(
          name: 'Mascaras & Lashes',
          icon: Icons.visibility,
          imageUrl: 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=300',
          leafCategories: ['Volume Mascaras', 'Lengthening Mascaras', 'Waterproof Mascaras', 'False Eyelashes', 'Eyelash Glue'],
        ),
        CategoryItem(
          name: 'Eyeshadows',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?q=80&w=300',
          leafCategories: ['Eyeshadow Palettes', 'Glitter Eyeshadows', 'Liquid Eyeshadows', 'Nude Palettes', 'Single Eyeshadows'],
        ),
        CategoryItem(
          name: 'Eyebrow Styling',
          icon: Icons.border_color,
          imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=300',
          leafCategories: ['Eyebrow Pencils', 'Eyebrow Gels', 'Eyebrow Powders', 'Brow Pomades', 'Brow Definers'],
        ),
        CategoryItem(
          name: 'Eye Prep & Primers',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=300',
          leafCategories: ['Eye Primers', 'Under-Eye Concealers', 'Lash Primers', 'Glitter Glue', 'Eye Makeup Base'],
        ),
      ],
    ),
    CategorySection(
      title: 'Nail Cosmetics',
      items: [
        CategoryItem(
          name: 'Nail Lacquers',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['Classic Polish', 'Matte Polish', 'Gel Finish Polish', 'Glitter Polish', 'Breathable Polish'],
        ),
        CategoryItem(
          name: 'Treatments & Coats',
          icon: Icons.shield,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['Glossy Top Coats', 'Matte Top Coats', 'Base Coats', 'Quick-Dry Drops', 'Nail Strengtheners'],
        ),
        CategoryItem(
          name: 'Nail Removers',
          icon: Icons.water,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Acetone Removers', 'Acetone-Free Removers', 'Dip-In Removers', 'Remover Wipes', 'Gel Polish Peels'],
        ),
        CategoryItem(
          name: 'Press-On & False Nails',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['Everyday Press-Ons', 'Festive Extensions', 'Short Square Nails', 'Almond Acrylic Tips', 'Nail Glue & Tabs'],
        ),
        CategoryItem(
          name: 'Nail Art & Tools',
          icon: Icons.build,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['Nail Stickers', 'Nail Art Brushes', 'Cuticle Pushers', 'Files & Buffers', 'Cuticle Oils'],
        ),
      ],
    ),
    CategorySection(
      title: 'Serums & Toners',
      items: [
        CategoryItem(
          name: 'Face Serums',
          icon: Icons.science,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Vitamin C Serums', 'Niacinamide Serums', 'Hyaluronic Serums', 'Salicylic Serums', 'Retinol Serums'],
        ),
        CategoryItem(
          name: 'Toners & Mists',
          icon: Icons.waves,
          imageUrl: 'https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=300',
          leafCategories: ['Hydrating Toners', 'Exfoliating Toners', 'Rose Water & Mists', 'Pore Tightening', 'Face Mists'],
        ),
        CategoryItem(
          name: 'Oils & Ampoules',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Kumkumadi Oils', 'Argan Facial Oils', 'Brightening Ampoules', 'Squalane Oils', 'Overnight Repair'],
        ),
        CategoryItem(
          name: 'Peeling Solutions',
          icon: Icons.dry,
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300',
          leafCategories: ['AHA BHA Peels', 'Glycolic Acid Peels', 'Lactic Acid Serums', 'Peeling Gels', 'Gentle Enzyme Peels'],
        ),
        CategoryItem(
          name: 'Targeted Treatments',
          icon: Icons.track_changes,
          imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?q=80&w=300',
          leafCategories: ['Dark Spot Correctors', 'Acne Spot Gels', 'Pigmentation Creams', 'Open Pore Serums', 'Under-Eye Serums'],
        ),
      ],
    ),
    CategorySection(
      title: 'Sunscreens, Cleansers & Moisturizers',
      items: [
        CategoryItem(
          name: 'Sun Protection',
          icon: Icons.sunny,
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300',
          leafCategories: ['Matte Sunscreens', 'Gel Sunscreens', 'Tinted Sunscreens', 'Sunscreen Sprays', 'Body Sunscreens'],
        ),
        CategoryItem(
          name: 'Face Cleansers',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=300',
          leafCategories: ['Foaming Face Washes', 'Gel Face Washes', 'Cream Cleansers', 'Salicylic Cleansers', 'Hydrating Cleansers'],
        ),
        CategoryItem(
          name: 'Day Moisturizers',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Oil-Free Gels', 'Lightweight Creams', 'Ceramide Moisturizers', 'Vitamin C Creams', 'Illuminating Creams'],
        ),
        CategoryItem(
          name: 'Night Care',
          icon: Icons.nightlight_round,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Night Creams', 'Sleeping Gels', 'Anti-Aging Creams', 'Barrier Repair Balms', 'Retinol Moisturizers'],
        ),
        CategoryItem(
          name: 'Makeup Cleansing',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=300',
          leafCategories: ['Micellar Waters', 'Cleansing Oils', 'Melting Balms', 'Waterproof Removers', 'Cleansing Milk'],
        ),
      ],
    ),
    CategorySection(
      title: 'Lip Balms & Masks',
      items: [
        CategoryItem(
          name: 'Daily Hydration',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Stick Lip Balms', 'Jar Lip Balms', 'SPF Lip Balms', 'Herbal Lip Balms', 'Flavor-Infused Balms'],
        ),
        CategoryItem(
          name: 'Tinted Lip Care',
          icon: Icons.face,
          imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=300',
          leafCategories: ['Pink Tinted Balms', 'Red Tinted Balms', 'Berry Tinted Balms', 'Nude Lip Balms', 'Color-Changing Balms'],
        ),
        CategoryItem(
          name: 'Overnight Repair',
          icon: Icons.nightlight_round,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Lip Sleeping Masks', 'Intensive Lip Butters', 'Night Lip Serums', 'Deep Repair Balms', 'Ceramide Lip Care'],
        ),
        CategoryItem(
          name: 'Exfoliator & Scrubs',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Sugar Lip Scrubs', 'Coffee Lip Scrubs', 'Lip Scrub Sticks', 'Exfoliating Brushes', 'Brightening Scrubs'],
        ),
        CategoryItem(
          name: 'Medicated Lip Balms',
          icon: Icons.medical_services,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Chapped Lip Care', 'Dark Lip Lighteners', 'Dermatologist Balms', 'Unscented Balms', 'Cold Sore Care'],
        ),
      ],
    ),
    CategorySection(
      title: 'Facial Kits & Face Masks',
      items: [
        CategoryItem(
          name: 'Sheet Masks',
          icon: Icons.face,
          imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=300',
          leafCategories: ['Hydrating Sheets', 'Brightening Sheets', 'Charcoal Sheets', 'Tea Tree Sheets', 'Mask Multipacks'],
        ),
        CategoryItem(
          name: 'Clay & Mud Masks',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=300',
          leafCategories: ['Bentonite Clay', 'Kaolin Pore Masks', 'Charcoal Detox', 'Multani Mitti Packs', 'Pink Clay Masks'],
        ),
        CategoryItem(
          name: 'Peel-Off Masks',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=300',
          leafCategories: ['Blackhead Peel-Offs', 'Golden Glow Peel-Offs', 'Vitamin C Peel-Offs', 'Tea Tree Peel-Offs', 'Firming Masks'],
        ),
        CategoryItem(
          name: 'Home Facial Kits',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=300',
          leafCategories: ['Gold Facial Kits', 'Diamond Glow Kits', 'Vitamin C Tan Kits', 'Bridal Facial Kits', 'Fruit Facial Kits'],
        ),
        CategoryItem(
          name: 'Face Scrubs & Packs',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=300',
          leafCategories: ['Walnut Scrubs', 'Apricot Face Scrubs', 'De-Tan Face Packs', 'Ubtan Packs', 'Aloe Vera Gels'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hair Color & Touch-up',
      items: [
        CategoryItem(
          name: 'Permanent Hair Color',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=300',
          leafCategories: ['Black Box Colors', 'Dark Brown Colors', 'Burgundy Box Colors', 'Natural Brown Colors', 'Vibrant Fashion Colors'],
        ),
        CategoryItem(
          name: 'Root Touch-Up',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=300',
          leafCategories: ['Instant Touch-Up Sprays', 'Color Sticks & Mascaras', 'Powder Root Concealers', 'Touch-Up Brushes', 'Compact Hair Powders'],
        ),
        CategoryItem(
          name: 'Ammonia-Free Color',
          icon: Icons.nature,
          imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=300',
          leafCategories: ['Oil-Infused Dyes', 'Ammonia-Free Creams', 'Gentle Hair Glosses', 'Nourishing Lotions', 'Semi-Permanent Dyes'],
        ),
        CategoryItem(
          name: 'Natural & Herbal Dyes',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=300',
          leafCategories: ['Pure Henna Powder', 'Indigo Powder', 'Herbal Hair Packs', 'Amla & Shikakai Dyes', 'Chemical-Free Dyes'],
        ),
        CategoryItem(
          name: 'Color Care',
          icon: Icons.shield,
          imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=300',
          leafCategories: ['Hair Color Shampoos', 'Purple Tone Shampoos', 'Depositing Conditioners', 'Color Protect Shampoos', 'Gray Cover Shampoos'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hair Masks & Serums',
      items: [
        CategoryItem(
          name: 'Hair Serums',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Anti-Frizz Serums', 'Smoothing Serums', 'Argan Oil Serums', 'Hair Growth Serums', 'Shine-Boosting Serums'],
        ),
        CategoryItem(
          name: 'Deep Conditioners',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Keratin Hair Masks', 'Hair Repair Masks', 'Ultra-Hydrating Masks', 'Color-Protect Masks', 'Spa Conditioning Cream'],
        ),
        CategoryItem(
          name: 'Heat Protection',
          icon: Icons.ac_unit,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Heat Protectant Sprays', 'Blow-Dry Creams', 'Straightening Serums', 'UV Hair Shields', 'Thermal Defense Mists'],
        ),
        CategoryItem(
          name: 'Hair Fluids & Tonics',
          icon: Icons.water,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Scalp Energizing Tonics', 'Leave-In Hair Fluids', 'Liquid Hair Supplements', 'Nourishing Hair Mists', 'Split-End Fluids'],
        ),
        CategoryItem(
          name: 'Repair Creams',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Split-End Repair', 'Bond Repair', 'Leave-In Repair Balms', 'Damaged Hair Moisture', 'Night Repair Elixirs'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hair Styling',
      items: [
        CategoryItem(
          name: 'Sprays & Holds',
          icon: Icons.waves,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Strong Hold Sprays', 'Flexible Finish Sprays', 'Texturizing Sea Salt', 'Shine Sprays', 'Setting Mists'],
        ),
        CategoryItem(
          name: 'Gels, Waxes & Pomades',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Strong Hold Gels', 'Matte Hair Waxes', 'High-Shine Pomades', 'Styling Clays', 'Edge Control Gels'],
        ),
        CategoryItem(
          name: 'Styling Mousses',
          icon: Icons.bubble_chart,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Volumizing Mousses', 'Curl Defining Mousses', 'Lightweight Foams', 'Thickening Mousses', 'Anti-Frizz Foams'],
        ),
        CategoryItem(
          name: 'Curl Care',
          icon: Icons.face,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Curl Defining Creams', 'Leave-In Curl Lotions', 'Activator Gels', 'Wave Enhancers', 'Detangling Curl Lotions'],
        ),
        CategoryItem(
          name: 'Volume & Texture',
          icon: Icons.grain,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Volumizing Powders', 'Root Lifting Sprays', 'Dry Texturizing Sprays', 'Hair Thickening Fibers', 'Matte Texturizers'],
        ),
      ],
    ),
    CategorySection(
      title: 'Shampoos & Oils',
      items: [
        CategoryItem(
          name: 'Daily Shampoos',
          icon: Icons.shower,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Hydrating Shampoos', 'Volumizing Shampoos', 'Color Protect Shampoos', 'Gentle Daily Wash', 'Sulfate-Free Shampoos'],
        ),
        CategoryItem(
          name: 'Conditioners',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Smoothing Conditioners', 'Deep Conditioners', 'Volumizing Conditioners', 'Moisture Lock Conditioners', 'Rinse-Out Creams'],
        ),
        CategoryItem(
          name: 'Targeted Shampoos',
          icon: Icons.track_changes,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Anti-Dandruff Shampoos', 'Anti-Hairfall Shampoos', 'Clarifying Shampoos', 'Keratin Shampoos', 'Onion Shampoos'],
        ),
        CategoryItem(
          name: 'Hair Growth & Scalp',
          icon: Icons.trending_up,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Rosemary Scalp Oils', 'Onion Hair Oils', 'Cold-Pressed Castor', 'Bhringraj Oils', 'Anti-Hairfall Oils'],
        ),
        CategoryItem(
          name: 'Nourishing Oils',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Pure Coconut Oils', 'Almond Hair Oils', 'Amla Hair Oils', 'Jasmine Scented Oils', 'Lightweight Daily Oils'],
        ),
      ],
    ),
    CategorySection(
      title: 'Bath & Body Tools',
      items: [
        CategoryItem(
          name: 'Loofahs & Sponges',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Classic Mesh Loofahs', 'Natural Bath Sponges', 'Charcoal Infused', 'Bath Poufs', 'Exfoliating Sponges'],
        ),
        CategoryItem(
          name: 'Body Scrubs & Mitts',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Korean Exfoliating Mitts', 'Silicone Body Scrubs', 'Loofah Pads', 'Exfoliating Gloves', 'Dual-Sided Body Mitts'],
        ),
        CategoryItem(
          name: 'Foot Care Tools',
          icon: Icons.airline_seat_legroom_extra,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Pumice Stones', 'Foot Files & Scrapers', 'Callus Removers', 'Pedicure Brushes', 'Metal Foot Rasps'],
        ),
        CategoryItem(
          name: 'Back Scrubbers',
          icon: Icons.dry,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Long Handle Brushes', 'Loofah Back Straps', 'Silicone Back Scrubbers', 'Wooden Body Brushes', 'Flexible Wash Bands'],
        ),
        CategoryItem(
          name: 'Dry Brushing',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Boar Bristle Brushes', 'Cellulite Massagers', 'Detox Dry Brushes', 'Long-Handle Dry Brushes', 'Handheld Body Brushes'],
        ),
      ],
    ),
    CategorySection(
      title: 'Beauty Accessories',
      items: [
        CategoryItem(
          name: 'Makeup Sponges',
          icon: Icons.face,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Teardrop Blenders', 'Hourglass Sponges', 'Mini Detail Sponges', 'Velvet Powder Puffs', 'Cushion Foundation Puffs'],
        ),
        CategoryItem(
          name: 'Makeup Brushes',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Foundation Brushes', 'Powder & Blush Brushes', 'Eyeshadow Brush Sets', 'Eyeliner & Brow Brushes', 'Full Brush Kits'],
        ),
        CategoryItem(
          name: 'Lash & Brow Tools',
          icon: Icons.visibility,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Eyelash Curlers', 'Eyebrow Tweezers', 'Lash Applicators', 'Brow Razors', 'Lash Combs & Spoolies'],
        ),
        CategoryItem(
          name: 'Cotton & Swabs',
          icon: Icons.grain,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Round Cotton Pads', 'Cotton Balls', 'Makeup Swabs', 'Reusable Bamboo Pads', 'Wet Makeup Wipes'],
        ),
        CategoryItem(
          name: 'Vanity Mirrors & Cases',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['LED Compact Mirrors', 'Handheld Mirrors', 'Travel Makeup Pouches', 'Acrylic Organizers', 'Brush Cleaning Mats'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hair Brushes & Tools',
      items: [
        CategoryItem(
          name: 'Daily Detanglers',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Flexi Detangling Brushes', 'Wide-Tooth Combs', 'Fine-Tooth Tail Combs', 'Pocket Combs', 'Neem Wooden Combs'],
        ),
        CategoryItem(
          name: 'Paddle Brushes',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Cushion Paddle Brushes', 'Wooden Paddle Brushes', 'Vent Paddle Brushes', 'Anti-Static Brushes', 'Large Styling Brushes'],
        ),
        CategoryItem(
          name: 'Round Styling Brushes',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Ceramic Round Brushes', 'Boar Bristle Round Brushes', 'Small Blow-Dry Brushes', 'Thermal Round Brushes', 'Medium Volumizing Brushes'],
        ),
        CategoryItem(
          name: 'Scalp Brushes',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Silicone Scalp Massagers', 'Shampoo Brushes', 'Dandruff Exfoliating Brushes', 'Scalp Circulation Brushes', 'Soft Bristle Brushes'],
        ),
        CategoryItem(
          name: 'Styling Combs',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Rat-Tail Parting Combs', 'Sectioning Clips', 'Teasing Brushes', 'Hot Combs', 'Hair Dressing Barber Combs'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hair & Nail Extensions',
      items: [
        CategoryItem(
          name: 'Temporary Hair Extension',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Colored Clip-In Streaks', 'One-Piece Volume Toppers', 'Clip-In Extensions', 'Fake Ponytails', 'Clip-In Hair Buns'],
        ),
        CategoryItem(
          name: 'Professional Extensions',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Tape-In Hair Bundles', 'I-Tip Extensions', 'Weft Hair Extensions', 'Keratin Bond Extensions', 'Invisible Halo Hair'],
        ),
        CategoryItem(
          name: 'Press-On Nails',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['French Manicure Press-Ons', 'Matte Finished Press-Ons', 'Festive Glitter Press-Ons', 'Short Everyday Nails', 'Coffin Shaped Nails'],
        ),
        CategoryItem(
          name: 'False Nail Tips',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['Clear Acrylic Nail Tips', 'Full Cover Nail Tips', 'Half Cover Tips', 'Toe Nail Extensions', 'Gel Nail Extensions'],
        ),
        CategoryItem(
          name: 'Adhesives & Removers',
          icon: Icons.shield,
          imageUrl: 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=300',
          leafCategories: ['Strong Nail Glue', 'Double-Sided Glue Tabs', 'Hair Extension Tape Rolls', 'Extension Glue Removers', 'Press-On Remover Liquids'],
        ),
      ],
    ),
    CategorySection(
      title: 'Luxury Beauty',
      items: [
        CategoryItem(
          name: 'Prestige Makeup',
          icon: Icons.star,
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300',
          leafCategories: ['Luxury Liquid Foundations', 'Designer Matte Lipsticks', 'Premium Eyeshadow Palettes', 'High-End Blushes', 'Prestige Primers'],
        ),
        CategoryItem(
          name: 'Luxury Skincare',
          icon: Icons.star,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Premium Treatment Essences', 'High-End Night Repair Serums', 'Luxury Eye Creams', 'Prestige Moisturizers', 'Luxury Face Oils'],
        ),
        CategoryItem(
          name: 'Premium Hair Care',
          icon: Icons.star,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Luxury Shampoos', 'Premium Hair Repair Masks', 'High-End Scalp Serums', 'Luxury Styling Oils', 'Prestige Elixirs'],
        ),
        CategoryItem(
          name: 'Elite Accessories',
          icon: Icons.star,
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300',
          leafCategories: ['24k Gold Face Rollers', 'Premium Sonic Cleansing Brushes', 'Luxury Silk Pillowcases', 'Designer Makeup Brush Sets', 'Premium Tweezing Sets'],
        ),
        CategoryItem(
          name: 'Luxury Travel Sets',
          icon: Icons.star,
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300',
          leafCategories: ['Designer Fragrance Miniatures', 'Luxury Skincare Travel Kits', 'Premium Makeup Palettes', 'High-End Body Care Trios', 'Elite Travel Pouches'],
        ),
      ],
    ),
    CategorySection(
      title: 'Perfumes & Gift Sets',
      items: [
        CategoryItem(
          name: "Women's Perfumes",
          icon: Icons.local_florist,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Eau de Parfum (EDP)', 'Eau de Toilette (EDT)', 'Luxury French Perfumes', 'Sweet & Floral Perfumes', 'Woody & Musk Perfumes'],
        ),
        CategoryItem(
          name: 'Body Mists & Deos',
          icon: Icons.waves,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Refreshing Body Mists', 'Gas-Free Deodorants', 'Scented Body Sprays', 'Long-Lasting Roll-Ons', 'Glitter Body Mists'],
        ),
        CategoryItem(
          name: 'Fragrance Gift Sets',
          icon: Icons.card_giftcard,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Perfume & Lotion Sets', 'Mini Perfume Box Sets', 'Luxury Gift Hampers', 'Couple Fragrance Packs', 'Birthday Gift Sets'],
        ),
        CategoryItem(
          name: 'On-the-Go Fragrances',
          icon: Icons.flight,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Pocket Perfumes', 'Rollerball Perfumes', 'Solid Perfume Balms', 'Atomizers & Refills', 'Travel Sprays'],
        ),
        CategoryItem(
          name: 'Traditional Fragrances',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=300',
          leafCategories: ['Pure Floral Attars', 'Oudh & Musk Concentrates', 'Sandalwood Oils', 'Non-Alcoholic Attar Roll-ons', 'Premium Jasmine Oils'],
        ),
      ],
    ),
    CategorySection(
      title: "Women's grooming",
      items: [
        CategoryItem(
          name: 'Facial Hair Removal',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Dermaplaning Facial Razors', 'Electric Facial Trimmers', 'Upper Lip Wax Strips', 'Facial Hair Removal Creams', 'Tweezing Tools'],
        ),
        CategoryItem(
          name: 'Body Shaving',
          icon: Icons.cut,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Multiblade Body Razors', 'Razor Cartridge Refills', 'Shaving Gels & Foams', 'Disposable Razors', 'Bikini Area Razors'],
        ),
        CategoryItem(
          name: 'Hair Removal Creams',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Sensitive Skin Creams', 'Spray-On Hair Removers', 'Underarm Removal Creams', 'Charcoal Hair Removal Creams', 'Post-Wash Lotions'],
        ),
        CategoryItem(
          name: 'Waxing at Home',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Cold Wax Strips', 'Hot Wax Cartridges', 'Katora/Bowl Wax', 'Pre-Wax Gels', 'Post-Wax Oil Cleansers'],
        ),
        CategoryItem(
          name: 'Electronic Groomers',
          icon: Icons.bolt,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Cordless Bikini Trimmers', 'Face & Body Epilators', 'Rechargeable Shavers', 'IPL Hair Removal Devices', 'Eyebrow Trimmer Pens'],
        ),
      ],
    ),
    CategorySection(
      title: "pregnancy time women's essentials",
      items: [
        CategoryItem(
          name: 'Maternity Skincare',
          icon: Icons.pregnant_woman,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Stretch Mark Lotions', 'Stretch Mark Oils', 'Hydrating Belly Butters', 'Anti-Itch Body Lotions', 'Soothing Nipple Balms'],
        ),
        CategoryItem(
          name: 'Maternity Support',
          icon: Icons.support,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Elastic Belly Support Bands', 'Maternity Belts', 'Pregnancy Compression Socks', 'Pelvic Support Bands', 'Postpartum Belts'],
        ),
        CategoryItem(
          name: 'Maternity Intimate Apparel',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Nursing Bras', 'Cotton Maternity Panties', 'Post-Delivery Disposable Briefs', 'Breast Pads', 'Leakproof Underwear'],
        ),
        CategoryItem(
          name: 'Maternity Comfort',
          icon: Icons.hotel,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['C-Shaped Pregnancy Pillows', 'U-Shaped Full Body Pillows', 'Cooling Gel Packs', 'Orthopedic Seat Cushions', 'Foot Relaxation Soaks'],
        ),
        CategoryItem(
          name: 'Pregnancy Safe Personal Care',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Chemical-Free Shampoos', 'Mineral Sunscreens', 'Unscented Body Washes', 'Aluminum-Free Deodorants', 'Natural Intimate Washes'],
        ),
      ],
    ),
    CategorySection(
      title: "women fitness & sports",
      items: [
        CategoryItem(
          name: 'High-Impact Apparel',
          icon: Icons.fitness_center,
          imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=300',
          leafCategories: ['High-Impact Sports Bras', 'Padded Running Bras', 'Compression Gym Leggings', 'Squat-Proof Tights', 'Workout Cycling Shorts'],
        ),
        CategoryItem(
          name: 'Active Tops & Tees',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=300',
          leafCategories: ['Moisture-Wicking Gym Tees', 'Dry-Fit Tank Tops', 'Cropped Gym Sweatshirts', 'Running Jackets', 'Sports Tank Tops'],
        ),
        CategoryItem(
          name: 'Workout Basics',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=300',
          leafCategories: ['High-Waisted Yoga Pants', 'Cotton Trackpants', 'Joggers', 'Athleisure Shorts', 'Sports Skirts'],
        ),
        CategoryItem(
          name: 'Fitness Gear',
          icon: Icons.sports,
          imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=300',
          leafCategories: ['Non-Slip Yoga Mats', 'Resistance Bands', 'Gym Gloves', 'Sweatbands & Headbands', 'Gym Shakers & Sippers'],
        ),
        CategoryItem(
          name: 'Athletic Socks',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=300',
          leafCategories: ['Cushioned Running Socks', 'Ankle-Length Gym Socks', 'Anti-Slip Pilates Socks', 'Compression Calf Socks', 'Cotton Sports Socks'],
        ),
      ],
    ),
    CategorySection(
      title: 'Travel & mobility',
      items: [
        CategoryItem(
          name: 'Luggage & Cases',
          icon: Icons.luggage,
          imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=300',
          leafCategories: ['Hard-Shell Carry-Ons', 'Soft Cabin Suitcases', 'Wheeled Duffle Bags', 'Underseat Flight Bags', 'Travel Garment Bags'],
        ),
        CategoryItem(
          name: 'Travel Packing Organizers',
          icon: Icons.grid_on,
          imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=300',
          leafCategories: ['Compression Packing Cubes', 'Waterproof Shoe Bags', 'Toiletry Pouches', 'Hanging Cosmetic Bags', 'Clear Tech Accessory Cases'],
        ),
        CategoryItem(
          name: 'In-Flight Comfort',
          icon: Icons.hotel,
          imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=300',
          leafCategories: ['Memory Foam Neck Pillows', 'Inflatable Pillows', 'Silk Eye Masks', 'Noise-Cancelling Earplugs', 'Travel Blankets'],
        ),
        CategoryItem(
          name: 'Travel Wallets & Security',
          icon: Icons.lock,
          imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=300',
          leafCategories: ['RFID Blocking Wallets', 'Passport Holder Covers', 'Crossbody Travel Pouches', 'Waist Money Belts', 'Luggage Locks & Tags'],
        ),
        CategoryItem(
          name: 'Travel Bottles & Liquids',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=300',
          leafCategories: ['Silicone Squeeze Bottles', 'Spray Travel Bottles', 'Mini Cream Jars', 'TSA-Approved Toiletry Kits', 'Perfume Atomizers'],
        ),
      ],
    ),
    CategorySection(
      title: 'books',
      items: [
        CategoryItem(
          name: 'Fiction & Literature',
          icon: Icons.book,
          imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300',
          leafCategories: ['Romance Novels', 'Contemporary Fiction', 'Historical Fiction', 'Literary Classics', 'Poetry Books'],
        ),
        CategoryItem(
          name: 'Mindset & Growth',
          icon: Icons.book,
          imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300',
          leafCategories: ['Self-Help Books', 'Personal Finance Books', 'Productivity Guides', 'Mindfulness Journals', 'Motivational Books'],
        ),
        CategoryItem(
          name: 'Crime & Mystery',
          icon: Icons.book,
          imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300',
          leafCategories: ['Psychological Thrillers', 'Murder Mysteries', 'Detective Novels', 'Spy Thrillers', 'True Crime Books'],
        ),
        CategoryItem(
          name: 'Biographies & History',
          icon: Icons.book,
          imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300',
          leafCategories: ['Memoirs', 'Inspiring Biographies', 'Indian History', 'World History', 'Women Achievers'],
        ),
        CategoryItem(
          name: 'Food & Lifestyle',
          icon: Icons.book,
          imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300',
          leafCategories: ['Indian Cookbooks', 'Baking Guides', 'Diet & Nutrition Books', 'Home Decor Guides', 'Fashion & Style Books'],
        ),
      ],
    ),
    CategorySection(
      title: 'Arts & crafts',
      items: [
        CategoryItem(
          name: 'Painting Supplies',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=300',
          leafCategories: ['Acrylic Paints', 'Watercolor Cakes', 'Oil Paint Sets', 'Canvas Boards', 'Artist Brush Sets'],
        ),
        CategoryItem(
          name: 'Sketching & Drawing',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=300',
          leafCategories: ['Graphite Pencils', 'Charcoal Sticks', 'Fineliner Pens', 'Sketchbook Journals', 'Colored Pencils'],
        ),
        CategoryItem(
          name: 'Needlework & Yarn',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=300',
          leafCategories: ['Crochet Yarn Skeins', 'Knitting Needles', 'Embroidery Hoop Kits', 'Cross-Stitch Threads', 'Crochet Hooks'],
        ),
        CategoryItem(
          name: 'DIY Hobby Kits',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=300',
          leafCategories: ['Candle Making Kits', 'Resin Art Starters', 'Pottery & Clay Kits', 'Soap Making Supplies', 'Macrame Cord Kits'],
        ),
        CategoryItem(
          name: 'Paper Crafts',
          icon: Icons.palette,
          imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=300',
          leafCategories: ['Origami Paper', 'Scrapbook Albums', 'Craft Cardstocks', 'Washi Tape Sets', 'Calligraphy Pens'],
        ),
      ],
    ),
    CategorySection(
      title: "women's footwear",
      items: [
        CategoryItem(
          name: 'Casual Footwear',
          icon: Icons.shopping_bag,
          imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=300',
          leafCategories: ['White Casual Sneakers', 'Slip-On Canvas Shoes', 'Ballets & Flats', 'Canvas Loafers', 'Mules'],
        ),
        CategoryItem(
          name: 'Festive & Heels',
          icon: Icons.shopping_bag,
          imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=300',
          leafCategories: ['Block Heels', 'Kitten Heels', 'Stilettos', 'Wedges', 'Traditional Ethnic Juttis'],
        ),
        CategoryItem(
          name: 'Sports & Running Footwear',
          icon: Icons.shopping_bag,
          imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=300',
          leafCategories: ['Cushioned Running Shoes', 'Gym Training Shoes', 'Walking Shoes', 'Trekking Shoes', 'Tennis Sneakers'],
        ),
        CategoryItem(
          name: 'Sandals & Open-Toe',
          icon: Icons.shopping_bag,
          imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=300',
          leafCategories: ['Gladiator Sandals', 'T-Strap Flats', 'Platform Sandals', 'Slide Sandals', 'Strappy Flat Sandals'],
        ),
        CategoryItem(
          name: 'Home & Beach Footwear',
          icon: Icons.shopping_bag,
          imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=300',
          leafCategories: ['Anti-Slip Flip-Flops', 'Rubber Slides', 'Plush Room Slippers', 'Orthopedic Comfort Slides', 'Beach Clogs'],
        ),
      ],
    ),
    CategorySection(
      title: 'bags & wallets',
      items: [
        CategoryItem(
          name: 'Everyday Bags',
          icon: Icons.card_membership,
          imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=300',
          leafCategories: ['Large Canvas Totes', 'Faux Leather Tote Bags', 'Office Laptop Bags', 'Hobo Bags', 'Shoulder Bags'],
        ),
        CategoryItem(
          name: 'Hands-Free Bags',
          icon: Icons.card_membership,
          imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=300',
          leafCategories: ['Crossbody Sling Bags', 'Compact Fanny Packs', 'Mini Backpacks', 'Leather Slings', 'Chest Bags'],
        ),
        CategoryItem(
          name: 'Travel & Work Backpacks',
          icon: Icons.card_membership,
          imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=300',
          leafCategories: ['Anti-Theft Backpacks', 'Laptop Backpacks', 'Casual Daypacks', 'Canvas Backpacks', 'Trekking Backpacks'],
        ),
        CategoryItem(
          name: 'Wallets & Pouches',
          icon: Icons.card_membership,
          imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=300',
          leafCategories: ['Long Zip-Around Wallets', 'Compact Trifold Wallets', 'Slim Card Cases', 'Coin Pouches', 'RFID Wallets'],
        ),
        CategoryItem(
          name: 'Party & Evening Bags',
          icon: Icons.card_membership,
          imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=300',
          leafCategories: ['Metallic Evening Clutches', 'Potli Bags', 'Rhinestone Bags', 'Box Clutches', 'Envelope Wristlets'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hire straighteners & dryers',
      items: [
        CategoryItem(
          name: 'Flat Irons & Straighteners',
          icon: Icons.bolt,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Ceramic Plate Straighteners', 'Titanium Flat Irons', 'Cordless Mini Straighteners', 'Keratin-Infused Irons', 'Wide-Plate Straighteners'],
        ),
        CategoryItem(
          name: 'Blow Dryers',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Ionic Hair Dryers', 'Professional AC Motor Dryers', 'Compact Travel Dryers', 'Quick-Dry Blow Dryers', 'Low-Noise Dryers'],
        ),
        CategoryItem(
          name: 'Curling Wands',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Conical Curling Wands', 'Automatic Hair Curlers', 'Thick Barrel Curlers', 'Triple Barrel Wave Irons', 'Thin Curling Tongs'],
        ),
        CategoryItem(
          name: 'Hot Air Brushes',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['One-Step Volumizing Brushes', 'Rotating Hot Air Brushes', 'Straightening Brushes', 'Heated Paddle Brushes', 'Oval Styler Brushes'],
        ),
        CategoryItem(
          name: 'Diffusers & Attachments',
          icon: Icons.settings,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Universal Diffusers', 'Concentrator Nozzles', 'Comb Attachments', 'Heat-Resistant Gloves', 'Replacement Nozzles'],
        ),
      ],
    ),
    CategorySection(
      title: 'pregnancy test kits',
      items: [
        CategoryItem(
          name: 'Rapid Pregnancy Detection',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=300',
          leafCategories: ['One-Step Test Strips', 'Early Detection Strips', 'Rapid Response Test Kits', 'Urine Collection Cups', 'Multi-Pack Test Cards'],
        ),
        CategoryItem(
          name: 'Midstream Devices',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=300',
          leafCategories: ['Midstream Test Pens', 'Splash-Free Test Devices', 'Direct Stream Test Kits', 'Ergonomic Detection Sticks', 'Comfort Test Pens'],
        ),
        CategoryItem(
          name: 'Digital Test Kits',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=300',
          leafCategories: ['Digital Clear Results', 'Weeks Indicator Tests', 'Smart Digital Kits', 'Backlit Screen Test Devices', 'Reusable Digital Readers'],
        ),
        CategoryItem(
          name: 'Fertility & Ovulation Planning',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=300',
          leafCategories: ['LH Ovulation Strip Packs', 'Digital Ovulation Predictors', 'Basal Body Thermometers', 'Ovulation Tracking Calendars', 'Fertility Combo Kits'],
        ),
        CategoryItem(
          name: 'Health Monitoring Bundles',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?q=80&w=300',
          leafCategories: ['Pregnancy & Ovulation Combo Packs', 'Multi-Brand Detection Packs', 'Bulk Hospital Strips', 'Early Confirmation Kits', 'Urine Strips'],
        ),
      ],
    ),
    CategorySection(
      title: 'wellness sex',
      items: [
        CategoryItem(
          name: 'Intimate Lubricants',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Water-Based Lubricants', 'Silicone-Based Lubricants', 'Flavored Lubricants', 'Warming Intimate Gels', 'Natural Organic Lubes'],
        ),
        CategoryItem(
          name: 'Personal Stimulation',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Handheld Bullet Massagers', 'Wand Massagers', 'Suction Massagers', 'Couple Clitoral Toys', 'Waterproof Body Massagers'],
        ),
        CategoryItem(
          name: 'Barrier Protection',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Ultra-Thin Condoms', 'Ribbed & Dotted Condoms', 'Flavored Condoms', 'Latex-Free Condoms', 'Female Condoms'],
        ),
        CategoryItem(
          name: 'Couples Massage Essentials',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Edible Massage Oils', 'Relaxing Lavender Oils', 'Warming Body Oils', 'Exotic Scented Lotions', 'Multi-Use Intimate Oils'],
        ),
        CategoryItem(
          name: 'Pelvic Health & Toning',
          icon: Icons.favorite,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Silicone Kegel Balls', 'Pelvic Floor Exercisers', 'Weighted Toning Balls', 'Smart Kegel Trainers', 'Pelvic Resistance Rings'],
        ),
      ],
    ),
    CategorySection(
      title: 'mehandi items',
      items: [
        CategoryItem(
          name: 'Ready Henna Cones',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Natural Brown Henna Cones', 'Instant Maroon Henna Cones', 'Organic Chemical-Free Cones', 'Black Mehandi Cones', 'Bridal Henna Cones'],
        ),
        CategoryItem(
          name: 'Pure Henna Powder',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Sojat Henna Powder', 'Triple Sifted Rajasthani Henna', 'Organic Herbal Henna', 'Hair Coloring Henna', 'Loose Natural Powder'],
        ),
        CategoryItem(
          name: 'Stencils & Stickers',
          icon: Icons.style,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Full Hand Mehandi Stencils', 'Arabic Design Stickers', 'Finger Henna Stencils', 'Bridal Lace Stickers', 'Kids Mehandi Stencils'],
        ),
        CategoryItem(
          name: 'Henna Oils & Prep',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Pure Eucalyptus Oils', 'Mehandi Scented Mix Oils', 'Clove Infused Oils', 'Color Enhancer Oils', 'Skin Prep Solutions'],
        ),
        CategoryItem(
          name: 'After-Care Products',
          icon: Icons.shield,
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=300',
          leafCategories: ['Henna Color Protecting Oils', 'Lemon Sugar Spray Bottles', 'Mehandi Protective Balms', 'Waterproof Sealant Sprays', 'Henna Scrapers'],
        ),
      ],
    ),
    CategorySection(
      title: 'spa & beauty accessories',
      items: [
        CategoryItem(
          name: 'Facial Rolling & Sculpting',
          icon: Icons.brush,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Jade Roller & Gua Sha Sets', 'Rose Quartz Rollers', 'Ice Rollers', 'Germanium Sculpting Wands', 'Ridged Facial Rollers'],
        ),
        CategoryItem(
          name: 'Face Steamers & Misters',
          icon: Icons.waves,
          imageUrl: 'https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=300',
          leafCategories: ['Nano Ionic Facial Steamers', 'Hot Mist Face Steamers', 'Portable USB Misters', 'Inhaler Steamers', 'Herbal Infusion Steamers'],
        ),
        CategoryItem(
          name: 'Spa Apparel & Wraps',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Satin Spa Headbands', 'Microfiber Wristbands', 'Terry Cloth Hair Wraps', 'Plush Spa Bathrobes', 'Adjustable Facial Towels'],
        ),
        CategoryItem(
          name: 'Aromatherapy & Mood',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Scented Soy Candles', 'Essential Oil Diffusers', 'Reed Diffusers', 'Lavender Pillow Mists', 'Spa Incense Sticks'],
        ),
        CategoryItem(
          name: 'Relaxation Eye Care',
          icon: Icons.remove_red_eye,
          imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=300',
          leafCategories: ['Weighted Lavender Eye Pillows', 'Satin Sleeping Masks', 'Gel Cooling Eye Masks', 'Self-Heating Steam Eye Masks', 'Silk Eye Covers'],
        ),
      ],
    ),
    CategorySection(
      title: 'Hair Daily Care',
      items: [
        CategoryItem(
          name: 'Leave-In Hydration',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Leave-In Styling Conditioners', 'Lightweight Hair Fluids', 'Split-End Lotions', 'Moisturizing Hair Milks', 'Anti-Frizz Lotions'],
        ),
        CategoryItem(
          name: 'Daily Detangling Mists',
          icon: Icons.waves,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Knot Release Sprays', 'Lightweight Detangling Mists', 'Kids Detangling Sprays', 'Conditioning Hair Mists', 'Shine Mists'],
        ),
        CategoryItem(
          name: 'Hair Supplements & Vitamins',
          icon: Icons.star,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Biotin Hair Gummies', 'Hair Health Vitamins', 'Keratin Dietary Capsules', 'Ayurvedic Hair Nutrients', 'Multi-Vitamin Hair Tablets'],
        ),
        CategoryItem(
          name: 'Scalp Tonics & Actives',
          icon: Icons.trending_up,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['Anti-Hairfall Scalp Serums', 'Rice Water Scalp Tonics', 'Energizing Caffeine Lotions', 'Tea Tree Scalp Fluids', 'Roots Strengthening Liquids'],
        ),
        CategoryItem(
          name: 'Environmental Defense',
          icon: Icons.shield,
          imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300',
          leafCategories: ['UV Protection Hair Mists', 'Anti-Pollution Hair Sprays', 'Chlorine Defense Mists', 'Sunblock Hair Lotions', 'Outdoor Shield Oils'],
        ),
      ],
    ),
    CategorySection(
      title: 'Bath Essentials',
      items: [
        CategoryItem(
          name: 'Liquid Body Washes',
          icon: Icons.bathtub,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Hydrating Body Washes', 'Exfoliating Shower Gels', 'Tea Tree Antibacterial Washes', 'Creamy Milk Body Washes', 'Aromatherapy Shower Gels'],
        ),
        CategoryItem(
          name: 'Bathing Soaps',
          icon: Icons.bathtub,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Handmade Glycerin Soaps', 'Charcoal Detox Bars', 'Moisturizing Cream Soaps', 'Herbal & Neem Bars', 'Exfoliating Scrub Soaps'],
        ),
        CategoryItem(
          name: 'Salts & Soaks',
          icon: Icons.bathtub,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Pure Epsom Salts', 'Lavender Bath Salts', 'Mineral Sea Salts', 'Detoxifying Foot Bath Salts', 'Pink Himalayan Salts'],
        ),
        CategoryItem(
          name: 'Bubble Baths',
          icon: Icons.bathtub,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Relaxing Lavender Bubble Baths', 'Eucalyptus Stress Relief Foams', 'Kids Gentle Bubble Baths', 'Sweet Vanilla Foam Liquids', 'Milky Bath Foams'],
        ),
        CategoryItem(
          name: 'Shower Caps & Covers',
          icon: Icons.checkroom,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Waterproof Double-Layer Caps', 'Reusable Satin Lined Caps', 'Disposable Shower Caps', 'Extra Large Hair Caps', 'Elastic Bath Bonnets'],
        ),
      ],
    ),
    CategorySection(
      title: 'Feminine Hygiene',
      items: [
        CategoryItem(
          name: 'Sanitary Pads',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Ultra-Thin Cotton Pads', 'Overnight Extra Large Pads', 'Organic Bamboo Pads', 'Rash-Free Sanitary Pads', 'Heavy Flow Winged Pads'],
        ),
        CategoryItem(
          name: 'Menstrual Cups & Care',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Small Menstrual Cups', 'Medium Menstrual Cups', 'Menstrual Cup Sterilizers', 'Intimate Cup Wash', 'Reusable Menstrual Discs'],
        ),
        CategoryItem(
          name: 'Tampons',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Applicator Tampons', 'Digital/No-Applicator Tampons', 'Organic Cotton Tampons', 'Super Absorbency Tampons', 'Regular Day Tampons'],
        ),
        CategoryItem(
          name: 'Daily Panty Liners',
          icon: Icons.wash,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['Ultra-Thin Panty Liners', 'Breathable Cotton Liners', 'Scented Daily Liners', 'Long Coverage Liners', 'Individual Wrap Liners'],
        ),
        CategoryItem(
          name: 'Intimate Cleansing',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=300',
          leafCategories: ['pH-Balanced Intimate Washes', 'Refreshing Intimate Wipes', 'Anti-Chafing Powders', 'Soothing Vaginal Gels', 'Intimate Foams'],
        ),
      ],
    ),
    CategorySection(
      title: 'Body Care',
      items: [
        CategoryItem(
          name: 'Daily Moisturizing Lotions',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Cocoa Butter Lotions', 'Aloe Vera Gel Lotions', 'Intensive Dry Skin Lotions', 'Vitamin E Body Lotions', 'Niacinamide Brightening Lotions'],
        ),
        CategoryItem(
          name: 'Deep Hydration Butters',
          icon: Icons.spa,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Pure Shea Body Butters', 'Mango Butter Creams', 'Coconut Body Creams', 'Whipped Body Butters', 'Nourishing Night Body Creams'],
        ),
        CategoryItem(
          name: 'Targeted Hand Care',
          icon: Icons.clean_hands,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Anti-Dryness Hand Creams', 'Antibacterial Hand Lotions', 'Cuticle Softening Creams', 'Scented Pocket Hand Creams', 'Heavy-Duty Hand Balms'],
        ),
        CategoryItem(
          name: 'Foot Repair',
          icon: Icons.airline_seat_legroom_extra,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Cracked Heel Healing Creams', 'Soothing Mint Foot Lotions', 'Urea Foot Peeling Creams', 'Anti-Odor Foot Sprays', 'Overnight Foot Balms'],
        ),
        CategoryItem(
          name: 'Body Polishing Oils',
          icon: Icons.opacity,
          imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300',
          leafCategories: ['Cold-Pressed Almond Oils', 'Glowing Body Oils', 'Non-Sticky Massage Oils', 'Ayurvedic Body Toning Oils', 'Vitamin C Glow Oils'],
        ),
      ],
    ),
  ];
}
