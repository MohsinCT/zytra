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
      title: '☀ Sunscreens & Moisturizers',
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
  ];
}
