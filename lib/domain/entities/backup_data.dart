import 'dart:convert';

import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product.dart';

class BackupData {
  final List<Category> categories;
  final List<Product> products;
  final List<OrderWithItemsParams> orderWithItems;

  BackupData({
    required this.categories,
    required this.products,
    required this.orderWithItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'categories': categories.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
      'orderWithItems': orderWithItems.map((x) => x.toMap()).toList(),
    };
  }

  factory BackupData.fromMap(Map<String, dynamic> map) {
    return BackupData(
      categories: List<Category>.from(map['categories']?.map((x) => Category.fromMap(x))),
      products: List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
      orderWithItems:
          List<OrderWithItemsParams>.from(map['orderWithItems']?.map((x) => OrderWithItemsParams.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BackupData.fromJson(String source) => BackupData.fromMap(json.decode(source));

  @override
  String toString() => 'BackupData(categories: $categories, products: $products, orderWithItems: $orderWithItems)';
}