import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sales/infrastucture/database/models/order_item_model.dart';
import 'package:sales/infrastucture/database/models/order_model.dart';
import 'package:sales/infrastucture/database/models/product_model.dart';

class RecentOrdersResultModel {
  final Map<OrderModel, List<OrderItemModel>> orderItems;
  final Map<OrderModel, List<ProductModel>> products;

  const RecentOrdersResultModel({
    required this.orderItems,
    required this.products,
  });

  RecentOrdersResultModel copyWith({
    Map<OrderModel, List<OrderItemModel>>? orderItems,
    Map<OrderModel, List<ProductModel>>? products,
  }) {
    return RecentOrdersResultModel(
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

  factory RecentOrdersResultModel.fromMap(Map<String, dynamic> map) {
    return RecentOrdersResultModel(
      orderItems: Map<OrderModel, List<OrderItemModel>>.from(map['orderItems']),
      products: Map<OrderModel, List<ProductModel>>.from(map['products']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentOrdersResultModel.fromJson(String source) => RecentOrdersResultModel.fromMap(json.decode(source));

  @override
  String toString() => 'RecentOrdersResult(orderItems: $orderItems, products: $products)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecentOrdersResultModel &&
        mapEquals(other.orderItems, orderItems) &&
        mapEquals(other.products, products);
  }

  @override
  int get hashCode => orderItems.hashCode ^ products.hashCode;
}
