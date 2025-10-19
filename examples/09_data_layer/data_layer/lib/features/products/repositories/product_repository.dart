import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:data_layer/features/products/models/product.dart';
import 'package:data_layer/features/products/models/category.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    final String response = await rootBundle.loadString(
      'assets/data/products.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Category>> getCategories() async {
    final String response = await rootBundle.loadString(
      'assets/data/categories.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Category.fromJson(json)).toList();
  }
}
