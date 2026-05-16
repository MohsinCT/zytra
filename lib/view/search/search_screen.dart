import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/model/product.dart';
import 'package:zytranow/services/product_service.dart';
import 'package:zytranow/controller/category_products_provider.dart';
import 'package:zytranow/utils/responsive.dart';

class SearchScreen extends StatefulWidget {
  final String? category;

  const SearchScreen({super.key, this.category});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get search results
    final List<Product> results = _query.isNotEmpty 
        ? ProductService.searchProducts(_query, category: widget.category)
        : [];
        
    final resp = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (val) {
                    setState(() {
                      _query = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: widget.category != null 
                        ? "Search in ${widget.category}..." 
                        : "What do you need?",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black54),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40),
                    suffixIcon: _query.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.black54),
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                _query = '';
                              });
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF2D6F),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search, color: Colors.white, size: 20),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            Expanded(
              child: _query.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 60, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            widget.category != null 
                                ? "Search within ${widget.category}" 
                                : "Search across all categories",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : results.isEmpty
                      ? Center(
                          child: Text("No products found for '$_query'", style: TextStyle(color: Colors.grey.shade600)),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: resp.scale(12), vertical: resp.scale(10)),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: resp.gridColumns,
                            mainAxisSpacing: resp.scale(12),
                            crossAxisSpacing: resp.scale(12),
                            childAspectRatio: resp.isDesktop ? 0.75 : 0.66,
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final p = results[index];
                            return _SearchProductCard(product: p, imageHeight: resp.productImageHeight);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// Copy of ProductCard from CategoryProductsScreen
class _SearchProductCard extends StatelessWidget {
  final Product product;
  final double imageHeight;
  const _SearchProductCard({required this.product, this.imageHeight = 110});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context);
    final qty = prov.quantityFor(product.id);
    final resp = Responsive.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(resp.scale(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + wishlist
              Stack(
                children: [
                  Container(
                    height: imageHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: product.imageAsset.isNotEmpty
                        ? Image.asset(product.imageAsset, width: resp.scale(90), height: resp.scale(90), fit: BoxFit.contain)
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
              SizedBox(height: resp.scale(8)),
              Text(product.unit, style: TextStyle(color: Colors.grey[600], fontSize: resp.scale(12))),
              SizedBox(height: resp.scale(6)),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  SizedBox(width: resp.scale(4)),
                  Text(product.deliveryTime, style: TextStyle(color: Colors.grey[600], fontSize: resp.scale(12))),
                ],
              ),
              SizedBox(height: resp.scale(8)),
              // tags
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: product.tags.map((t) => Container(
                    padding: EdgeInsets.symmetric(horizontal: resp.scale(8), vertical: resp.scale(4)),
                    decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(t, style: TextStyle(fontSize: resp.scale(11), color: Colors.pink)),
                  )).toList(),
                ),
              const Spacer(),
              // bottom row: price + add
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: resp.scale(14), color: Colors.black)),
                        SizedBox(height: resp.scale(2)),
                        Text(
                          product.name, 
                          style: TextStyle(color: Colors.grey[800], fontSize: MediaQuery.of(context).size.width * 0.03), 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  qty > 0 ? _SearchQtyControls(productId: product.id, qty: qty) : _SearchAddButton(productId: product.id),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchAddButton extends StatelessWidget {
  final String productId;
  const _SearchAddButton({required this.productId});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => prov.increment(productId),
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
    );
  }
}

class _SearchQtyControls extends StatelessWidget {
  final String productId;
  final int qty;
  const _SearchQtyControls({required this.productId, required this.qty});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, size: 18), 
            onPressed: () => prov.decrement(productId)
          ),
          Text(qty.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, size: 18, color: Color(0xFFFF2D7A)), 
            onPressed: () => prov.increment(productId)
          ),
        ],
      ),
    );
  }
}
