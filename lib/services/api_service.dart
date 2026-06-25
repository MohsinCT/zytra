import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:zytranow/models/product.dart';

/*
================================================================================
                    NODE.JS & MONGODB BACKEND CONTRACT
================================================================================

This Flutter app is designed to connect to a Node.js + Express + MongoDB backend.
Below are the EXACT blueprints for your Express routes, Mongoose schema,
and seed scripts. You can copy-paste this straight into your backend!

--------------------------------------------------------------------------------
1. MONGOOSE SCHEMA (models/Product.js)
--------------------------------------------------------------------------------
const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // custom formatted ID e.g., 'lip_gloss_1'
  name: { type: String, required: true },
  imageAsset: { type: String, required: true }, // Primary image URL (e.g. Unsplash)
  unit: { type: String, default: '50 ml' }, // Unit description (e.g., '1 Unit', '100 ml')
  price: { type: Number, required: true }, // Current active selling price
  mrp: { type: Number, default: 0 }, // Maximum Retail Price (strike-through)
  deliveryTime: { type: String, default: '10 mins' }, // e.g. '8 mins'
  rating: { type: Number, default: 4.5 },
  reviews: { type: Number, default: 120 },
  description: { type: String, default: '' },
  soldCount: { type: Number, default: 0 }, // e.g. 16 for '16k+ sold recently'
  brand: { type: String, default: 'Zytra' },
  category: { type: String, required: true }, // Category or Subcategory
  images: [{ type: String }], // Array of carousel image URLs (5 images)
  specifications: { type: Map, of: String, default: {} }, // Key-value specifications
  variants: [{ type: String }], // Available variant lists (shades, sizes, etc.)
  tags: [{ type: String }] // e.g. ['Bestseller', 'Trending']
}, { timestamps: true });

module.exports = mongoose.model('Product', ProductSchema);

--------------------------------------------------------------------------------
2. EXPRESS ROUTES (routes/products.js)
--------------------------------------------------------------------------------
const express = require('express');
const router = express.Router();
const Product = require('../models/Product');

// A. Get all products (supports category filtering e.g. GET /api/products?category=Eye%20Makeup)
router.get('/', async (req, res) => {
  try {
    const filter = {};
    if (req.query.category) {
      filter.category = req.query.category;
    }
    const products = await Product.find(filter);
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// B. Get popular/trending products (GET /api/products/popular)
router.get('/popular', async (req, res) => {
  try {
    // Return bestselling or highest rated products
    const popular = await Product.find({ tags: 'Bestseller' }).limit(10);
    if (popular.length === 0) {
      // Fallback to top 6 if no Bestseller tag exists yet
      return res.json(await Product.find().limit(6));
    }
    res.json(popular);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// C. Search products (GET /api/products/search?q=lipstick)
router.get('/search', async (req, res) => {
  try {
    const query = req.query.q || '';
    const products = await Product.find({
      $or: [
        { name: { $regex: query, $options: 'i' } },
        { brand: { $regex: query, $options: 'i' } },
        { category: { $regex: query, $options: 'i' } }
      ]
    });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// D. Get product by ID with populating similar products (GET /api/products/:id)
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findOne({ id: req.params.id });
    if (!product) return res.status(404).json({ message: 'Product not found' });
    
    // Fetch 4 similar products from the same category
    const similar = await Product.find({ 
      category: product.category, 
      id: { $ne: product.id } 
    }).limit(4);

    const result = {
      ...product.toObject(),
      similarProducts: similar
    };
    
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
================================================================================
*/

class ApiConfig {
  /// Dynamic Base URL detection for seamless cross-device backend testing.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else if (Platform.isAndroid) {
      // 10.0.2.2 is the special Android loopback alias pointing to your laptop's localhost server.
      return 'http://10.0.2.2:5000/api';
    } else {
      // iOS simulators can access localhost loopback directly.
      return 'http://localhost:5000/api';
    }
  }
}

class ApiService {
  /// Central HTTP GET request wrapper with dynamic host routing & offline fallback execution.
  static Future<List<Product>> _getProductsList(
    String path, {
    Map<String, String>? queryParams,
    required List<Product> offlineFallback,
  }) async {
    try {
      Uri uri = Uri.parse('${ApiConfig.baseUrl}$path');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      dev.log('📡 [ApiService] Sending GET request to: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        dev.log('✅ [ApiService] Loaded ${decoded.length} items from server.');
        return decoded.map((item) => Product.fromJson(item)).toList();
      } else {
        dev.log(
          '⚠️ [ApiService] Server returned non-200 status code: ${response.statusCode}',
        );
        return offlineFallback;
      }
    } catch (e) {
      dev.log('🔌 [ApiService] Connection failed: ${e.toString()}');
      dev.log(
        '👉 [ApiService] Returning offline mock fallback data. Ready for offline testing!',
      );
      return offlineFallback;
    }
  }

  /// Fetches products matching a specific category.
  /// Node.js Equivalent: GET /api/products?category=CategoryName
  static Future<List<Product>> getProductsByCategory(
    String categoryName,
    List<Product> offlineFallback,
  ) async {
    return _getProductsList(
      '/products',
      queryParams: {'category': categoryName},
      offlineFallback: offlineFallback,
    );
  }

  /// Fetches popular trending products for the home screen.
  /// Node.js Equivalent: GET /api/products/popular
  static Future<List<Product>> getPopularProducts(
    List<Product> offlineFallback,
  ) async {
    return _getProductsList(
      '/products/popular',
      offlineFallback: offlineFallback,
    );
  }

  /// Searches products matching a dynamic query.
  /// Node.js Equivalent: GET /api/products/search?q=lipstick
  static Future<List<Product>> searchProducts(
    String query,
    List<Product> offlineFallback,
  ) async {
    return _getProductsList(
      '/products/search',
      queryParams: {'q': query},
      offlineFallback: offlineFallback,
    );
  }

  /// Fetches complete details of a single product including related items.
  /// Node.js Equivalent: GET /api/products/:id
  static Future<Product> getProductById(
    String id,
    Product offlineFallback,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/products/$id');
      dev.log('📡 [ApiService] Sending GET request to: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        dev.log('✅ [ApiService] Loaded product details from server.');
        return Product.fromJson(decoded);
      } else {
        dev.log(
          '⚠️ [ApiService] Server returned non-200 code: ${response.statusCode}',
        );
        return offlineFallback;
      }
    } catch (e) {
      dev.log('🔌 [ApiService] Connection failed: ${e.toString()}');
      dev.log('👉 [ApiService] Returning offline product fallback.');
      return offlineFallback;
    }
  }
}
