import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';

class RecentOrdersResult {
  final Map<Order, List<OrderItem>> orderItems;
  final Map<Order, List<Product>> products;

  const RecentOrdersResult({
    required this.orderItems,
    required this.products,
  });

  RecentOrdersResult copyWith({
    Map<Order, List<OrderItem>>? orderItems,
    Map<Order, List<Product>>? products,
  }) {
    return RecentOrdersResult(
      orderItems: orderItems ?? this.orderItems,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderItems': orderItems,
      'products': products,
    };
  }

  factory RecentOrdersResult.fromMap(Map<String, dynamic> map) {
    return RecentOrdersResult(
      orderItems: Map<Order, List<OrderItem>>.from(map['orderItems']),
      products: Map<Order, List<Product>>.from(map['products']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentOrdersResult.fromJson(String source) => RecentOrdersResult.fromMap(json.decode(source));

  @override
  String toString() => 'RecentOrdersResult(orderItems: $orderItems, products: $products)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecentOrdersResult &&
        mapEquals(other.orderItems, orderItems) &&
        mapEquals(other.products, products);
  }

  @override
  int get hashCode => orderItems.hashCode ^ products.hashCode;
}
