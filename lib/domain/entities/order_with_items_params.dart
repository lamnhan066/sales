import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';

class OrderWithItemsParams with EquatableMixin {

  OrderWithItemsParams({
    required this.order,
    required this.orderItems,
  });

  factory OrderWithItemsParams.fromMap(Map<String, dynamic> map) {
    return OrderWithItemsParams(
      order: Order.fromMap(map['order']),
      orderItems: List<OrderItem>.from(map['orderItems']?.map((x) => OrderItem.fromMap(x))),
    );
  }

  factory OrderWithItemsParams.fromJson(String source) => OrderWithItemsParams.fromMap(json.decode(source));
  final Order order;
  final List<OrderItem> orderItems;

  @override
  List<Object> get props => [order, orderItems];

  Map<String, dynamic> toMap() {
    return {
      'order': order.toMap(),
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
