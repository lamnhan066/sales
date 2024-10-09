import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/product.dart';

class RecentOrdersResult with EquatableMixin {
  final Map<Order, List<OrderItem>> orderItems;
  final Map<Order, List<Product>> products;

  const RecentOrdersResult({
    this.orderItems = const {},
    this.products = const {},
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
  List<Object> get props => [orderItems, products];
}
