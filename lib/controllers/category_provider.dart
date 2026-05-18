import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;

  CategoryItem({required this.name, required this.icon});
}

class CategorySection {
  final String title;
  final List<CategoryItem> items;

  CategorySection({required this.title, required this.items});
}

class CategoryProvider extends ChangeNotifier {
  final List<CategorySection> sections = [
    CategorySection(
      title: '👗 Fashion & Clothing',
      items: [
        CategoryItem(name: 'Oversized T-Shirt', icon: Icons.checkroom),
        CategoryItem(name: 'Cargo Pants', icon: Icons.checkroom),
        CategoryItem(name: 'Summer Dress', icon: Icons.checkroom),
        CategoryItem(name: 'Crop Top', icon: Icons.checkroom),
        CategoryItem(name: 'Hoodie Jacket', icon: Icons.checkroom),
        CategoryItem(name: 'Straight Fit Jeans', icon: Icons.checkroom),
      ],
    ),
    CategorySection(
      title: '💄 Lip Cosmetics',
      items: [
        CategoryItem(name: 'Matte Lipstick', icon: Icons.opacity),
        CategoryItem(name: 'Lip Gloss', icon: Icons.opacity),
        CategoryItem(name: 'Lip Liner', icon: Icons.edit),
        CategoryItem(name: 'Lip Oil', icon: Icons.opacity),
        CategoryItem(name: 'Lip Cream', icon: Icons.opacity),
        CategoryItem(name: 'Lip Tint', icon: Icons.color_lens),
      ],
    ),
    CategorySection(
      title: '✨ Face Cosmetics',
      items: [
        CategoryItem(name: 'Foundation', icon: Icons.blur_on),
        CategoryItem(name: 'Compact Powder', icon: Icons.circle),
        CategoryItem(name: 'BB Cream', icon: Icons.brightness_6),
        CategoryItem(name: 'Blush', icon: Icons.palette),
        CategoryItem(name: 'Highlighter', icon: Icons.wb_sunny),
        CategoryItem(name: 'Concealer', icon: Icons.remove_red_eye),
      ],
    ),
    CategorySection(
      title: '👁 Eye Makeup',
      items: [
        CategoryItem(name: 'Eyeliner', icon: Icons.brush),
        CategoryItem(name: 'Mascara', icon: Icons.blur_circular),
        CategoryItem(name: 'Eyeshadow', icon: Icons.palette),
        CategoryItem(name: 'Eyebrow Pencil', icon: Icons.create),
        CategoryItem(name: 'Eye Pigment', icon: Icons.auto_awesome),
        CategoryItem(name: 'Kajal', icon: Icons.remove_red_eye),
      ],
    ),
    CategorySection(
      title: '💅 Nail Cosmetics',
      items: [
        CategoryItem(name: 'Gel Polish', icon: Icons.brush),
        CategoryItem(name: 'Matte Paint', icon: Icons.format_paint),
        CategoryItem(name: 'Nail Remover', icon: Icons.remove_circle_outline),
        CategoryItem(name: 'Nail Strengthener', icon: Icons.fitness_center),
        CategoryItem(name: 'Glitter Coat', icon: Icons.auto_awesome),
        CategoryItem(name: 'Nail Art Kit', icon: Icons.build),
      ],
    ),
    CategorySection(
      title: '🧴 Serums & Toners',
      items: [
        CategoryItem(name: 'Vitamin C Serum', icon: Icons.bubble_chart),
        CategoryItem(name: 'Hyaluronic Serum', icon: Icons.opacity),
        CategoryItem(name: 'Niacinamide Serum', icon: Icons.science),
        CategoryItem(name: 'Rose Toner', icon: Icons.local_florist),
        CategoryItem(name: 'Green Tea Toner', icon: Icons.eco),
        CategoryItem(name: 'Brightening Serum', icon: Icons.wb_incandescent),
      ],
    ),
    CategorySection(
      title: '☀ Sunscreens, Cleansers & Moisturizers',
      items: [
        CategoryItem(name: 'SPF 50 Sunscreen', icon: Icons.shield),
        CategoryItem(name: 'Face Cleanser', icon: Icons.cleaning_services),
        CategoryItem(name: 'Aloe Moisturizer', icon: Icons.water_drop),
        CategoryItem(name: 'Oil-Free Sunscreen', icon: Icons.wb_sunny),
        CategoryItem(name: 'Face Wash', icon: Icons.bathroom),
        CategoryItem(name: 'Moisture Cream', icon: Icons.brightness_5),
      ],
    ),
    CategorySection(
      title: '💋 Lip Balms & Masks',
      items: [
        CategoryItem(name: 'Strawberry Balm', icon: Icons.icecream),
        CategoryItem(name: 'Overnight Mask', icon: Icons.bedtime),
        CategoryItem(name: 'Shea Butter Balm', icon: Icons.spa),
        CategoryItem(name: 'Tinted Balm', icon: Icons.color_lens),
        CategoryItem(name: 'Honey Lip Mask', icon: Icons.hive),
        CategoryItem(name: 'Vitamin E Balm', icon: Icons.health_and_safety),
      ],
    ),
    CategorySection(
      title: '💆 Facial Kits & Face Masks',
      items: [
        CategoryItem(name: 'Gold Facial Kit', icon: Icons.face),
        CategoryItem(name: 'Charcoal Mask', icon: Icons.blur_on),
        CategoryItem(name: 'Brightening Sheet Mask', icon: Icons.layers),
        CategoryItem(name: 'Detoxifying Clay Mask', icon: Icons.spa),
        CategoryItem(name: 'Anti-Aging Facial Kit', icon: Icons.auto_awesome),
        CategoryItem(name: 'Hydrating Sleeping Mask', icon: Icons.water_drop),
      ],
    ),
    CategorySection(
      title: '💇 Hair Color & Touch-up',
      items: [
        CategoryItem(name: 'Root Touch-up Spray', icon: Icons.person),
        CategoryItem(name: 'Burgundy Hair Dye', icon: Icons.color_lens),
        CategoryItem(name: 'Ammonia-Free Black', icon: Icons.palette),
        CategoryItem(
          name: 'Temporary Highlight Wax',
          icon: Icons.auto_fix_high,
        ),
        CategoryItem(name: 'Brown Color Cream', icon: Icons.format_paint),
        CategoryItem(name: 'Herbal Henna Powder', icon: Icons.eco),
      ],
    ),
    CategorySection(
      title: '🧴 Hair Masks & Serums',
      items: [
        CategoryItem(name: 'Argan Hair Serum', icon: Icons.opacity),
        CategoryItem(name: 'Keratin Deep Mask', icon: Icons.spa),
        CategoryItem(name: 'Anti-Frizz Oil Serum', icon: Icons.bubble_chart),
        CategoryItem(name: 'Nourishing Coconut Mask', icon: Icons.water_drop),
        CategoryItem(name: 'Shine Booster Serum', icon: Icons.auto_awesome),
        CategoryItem(name: 'Dry Damage Repair Mask', icon: Icons.healing),
      ],
    ),
    CategorySection(
      title: '💇 Hair Styling',
      items: [
        CategoryItem(name: 'Styling Wax', icon: Icons.auto_fix_high),
        CategoryItem(name: 'Curl Cream', icon: Icons.change_circle),
        CategoryItem(name: 'Hair Spray', icon: Icons.air),
        CategoryItem(name: 'Heat Protection', icon: Icons.security),
        CategoryItem(name: 'Hair Mousse', icon: Icons.bubble_chart),
        CategoryItem(name: 'Styling Gel', icon: Icons.build),
      ],
    ),
    CategorySection(
      title: '🚿 Shampoos & Oils',
      items: [
        CategoryItem(name: 'Anti-Dandruff Shampoo', icon: Icons.shower),
        CategoryItem(name: 'Onion Growth Hair Oil', icon: Icons.opacity),
        CategoryItem(name: 'Herbal Mild Shampoo', icon: Icons.eco),
        CategoryItem(name: 'Pure Coconut Hair Oil', icon: Icons.water_drop),
        CategoryItem(name: 'Protein Keratin Shampoo', icon: Icons.bolt),
        CategoryItem(name: 'Ayurvedic Bhringraj Oil', icon: Icons.spa),
      ],
    ),
    CategorySection(
      title: '🧼 Bath & Body Tools',
      items: [
        CategoryItem(name: 'Exfoliating Loofah', icon: Icons.bubble_chart),
        CategoryItem(name: 'Pumice Stone Scrub', icon: Icons.circle),
        CategoryItem(name: 'Body Wash Sponge', icon: Icons.wash),
        CategoryItem(name: 'Silicone Body Brush', icon: Icons.brush),
        CategoryItem(name: 'Moisturizing Bath Mitts', icon: Icons.clean_hands),
        CategoryItem(name: 'Exfoliating Back Scrubber', icon: Icons.texture),
      ],
    ),
    CategorySection(
      title: '🛍 Beauty Accessories',
      items: [
        CategoryItem(name: 'Makeup Organizer', icon: Icons.storage),
        CategoryItem(name: 'Makeup Sponge', icon: Icons.circle),
        CategoryItem(name: 'Eyelash Curler', icon: Icons.remove_red_eye),
        CategoryItem(name: 'Compact Mirror', icon: Icons.visibility),
        CategoryItem(name: 'Beauty Blender', icon: Icons.blur_circular),
        CategoryItem(name: 'Cotton Pad Box', icon: Icons.layers),
      ],
    ),
    CategorySection(
      title: '🪮 Hair Brushes & Tools',
      items: [
        CategoryItem(name: 'Paddle Hair Brush', icon: Icons.brush),
        CategoryItem(name: 'Round Blowdry Brush', icon: Icons.circle),
        CategoryItem(
          name: 'Detangling Fine Comb',
          icon: Icons.grid_goldenratio,
        ),
        CategoryItem(name: 'Sectioning Hair Clips', icon: Icons.content_cut),
        CategoryItem(name: 'Wide Tooth Comb', icon: Icons.grid_view),
        CategoryItem(name: 'Hair Trimming Shears', icon: Icons.handyman),
      ],
    ),
    CategorySection(
      title: '💎 Hair & Nail Extensions',
      items: [
        CategoryItem(name: 'Clip-in Hair Extension', icon: Icons.style),
        CategoryItem(name: 'French Tip Press-on Nails', icon: Icons.back_hand),
        CategoryItem(name: 'Colored Hair Streak Clip', icon: Icons.color_lens),
        CategoryItem(name: 'Matte Coffin Acrylic Nails', icon: Icons.circle),
        CategoryItem(name: 'Hair Volume Bun Maker', icon: Icons.bubble_chart),
        CategoryItem(name: 'Self-Adhesive False Nails', icon: Icons.brush),
      ],
    ),
    CategorySection(
      title: '🏆 Luxury Beauty',
      items: [
        CategoryItem(
          name: 'Luxury 24k Gold Serum',
          icon: Icons.workspace_premium,
        ),
        CategoryItem(
          name: 'Premium Velvet Foundation',
          icon: Icons.auto_awesome,
        ),
        CategoryItem(name: 'Designer Lip Suede', icon: Icons.opacity),
        CategoryItem(name: 'Caviar Repair Face Cream', icon: Icons.spa),
        CategoryItem(name: 'Luxury Fragrant Mist', icon: Icons.air),
        CategoryItem(name: 'Elite Master Makeup Kit', icon: Icons.star),
      ],
    ),
    CategorySection(
      title: '🎁 Perfumes & Gift Sets',
      items: [
        CategoryItem(name: 'Floral Romance Perfume', icon: Icons.local_florist),
        CategoryItem(name: 'Warm Vanilla Body Mist', icon: Icons.smoke_free),
        CategoryItem(
          name: 'Luxury Blossom Gift Box',
          icon: Icons.card_giftcard,
        ),
        CategoryItem(name: 'Velvet Rose Deo Combo', icon: Icons.redeem),
        CategoryItem(name: 'Premium Unisex Perfumes', icon: Icons.spa),
        CategoryItem(name: 'Sweet Lavender Body Set', icon: Icons.bathtub),
      ],
    ),
    CategorySection(
      title: '🪒 Women’s Grooming',
      items: [
        CategoryItem(name: 'Precision Eyebrow Razor', icon: Icons.brush),
        CategoryItem(name: 'Facial Hair Epilator', icon: Icons.electric_bolt),
        CategoryItem(name: 'Sensitive Bikini Trimmer', icon: Icons.cut),
        CategoryItem(name: 'Body Razor Glide Kit', icon: Icons.clean_hands),
        CategoryItem(name: 'Mini Grooming Scissors', icon: Icons.handyman),
        CategoryItem(name: 'Ready-to-use Wax Strips', icon: Icons.layers),
      ],
    ),
  ];
}
