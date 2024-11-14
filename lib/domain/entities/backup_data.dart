import 'dart:convert';

import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product.dart';

class BackupData {
  BackupData({
    required this.categories,
    required this.products,
    required this.orderWithItems,
    required this.discounts,
  });

  factory BackupData.fromMap(Map<String, dynamic> map) {
    return BackupData(
      categories: List<Category>.from(map['categories']!.map((x) => Category.fromMap(x))),
      products: List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
      orderWithItems:
          List<OrderWithItemsParams>.from(map['orderWithItems']?.map((x) => OrderWithItemsParams.fromMap(x))),
      discounts: List<Discount>.from(map['discounts']?.map((x) => Discount.fromMap(x))),
    );
  }

  factory BackupData.fromJson(String source) => BackupData.fromMap(json.decode(source));
  final List<Category> categories;
  final List<Product> products;
  final List<OrderWithItemsParams> orderWithItems;
  final List<Discount> discounts;

  Map<String, dynamic> toMap() {
    return {
      'categories': categories.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
      'orderWithItems': orderWithItems.map((x) => x.toMap()).toList(),
      'discounts': discounts.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BackupData(categories: $categories, products: $products, orderWithItems: $orderWithItems, discounts: $discounts)';
  }
}
