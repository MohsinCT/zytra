import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controller/category_products_provider.dart';
import 'package:zytranow/model/product.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
      prov.loadCategory(widget.categoryName);
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context);
    final products = prov.products;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.categoryName, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune, color: Colors.black)),
        ],
      ),
      body: Column(
        children: [
          // Filters row
          SizedBox(
            height: 64,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: const [
                _FilterChip(label: 'Filters'),
                SizedBox(width: 8),
                _FilterChip(label: 'Sort'),
                SizedBox(width: 8),
                _FilterChip(label: 'Price'),
                SizedBox(width: 8),
                _FilterChip(label: 'Brand'),
                SizedBox(width: 8),
                _FilterChip(label: 'Type'),
              ],
            ),
          ),

          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: _CategoryBanner(category: widget.categoryName),
          ),

          // Products grid
          Expanded(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.66,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return _ProductCard(product: p);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => selected = !selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? const Color(0xFFFF2D7A) : Colors.grey.shade300),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0,1))],
        ),
        child: Text(widget.label, style: TextStyle(color: selected ? const Color(0xFFFF2D7A) : Colors.grey[800])),
      ),
    );
  }
}

class _CategoryBanner extends StatelessWidget {
  final String category;
  const _CategoryBanner({required this.category});

  @override
  Widget build(BuildContext context) {
    final text = _bannerTextFor(category);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [Color(0xFFFF2D7A), Color(0xFFFF6A9A)]),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0,3))],
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          // small illustration placeholder
          const SizedBox(width: 12),
          Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8))),
        ],
      ),
    );
  }

  String _bannerTextFor(String category) {
    final c = category.toLowerCase();
    if (c.contains('weather')) return 'Rainy Day Essentials Delivered in Minutes';
    if (c.contains('electrical')) return 'Daily Electrical Needs Instantly Available';
    return '$category Delivered in Minutes';
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context);
    final qty = prov.quantityFor(product.id);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + wishlist
              Stack(
                children: [
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: product.imageAsset.isNotEmpty
                        ? Image.asset(product.imageAsset, width: 90, height: 90, fit: BoxFit.contain)
                        : const SizedBox.shrink(),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, size: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(product.unit, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(product.deliveryTime, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              // tags
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: product.tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.pink)),
                  )).toList(),
                ),
              const Spacer(),
              // bottom row: price + add
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                      const SizedBox(height: 2),
                      SizedBox(width: 140, child: Text(product.name, style: TextStyle(color: Colors.grey[800], fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  qty > 0 ? _QtyControls(productId: product.id, qty: qty) : _AddButton(productId: product.id),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final String productId;
  const _AddButton({required this.productId});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        await _controller.forward();
        _controller.reverse();
        prov.increment(widget.productId);
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFF2D7A)),
            boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0,2))],
          ),
          child: const Text('ADD', style: TextStyle(color: Color(0xFFFF2D7A), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _QtyControls extends StatelessWidget {
  final String productId;
  final int qty;
  const _QtyControls({required this.productId, required this.qty});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: () => prov.decrement(productId)),
          Text(qty.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add, size: 18, color: Color(0xFFFF2D7A)), onPressed: () => prov.increment(productId)),
        ],
      ),
    );
  }
}
