import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';

class OrderWithItemsParamsModel with EquatableMixin {
  OrderWithItemsParamsModel({
    required this.order,
    required this.orderItems,
  });

  factory OrderWithItemsParamsModel.fromMap(Map<String, dynamic> map) {
    return OrderWithItemsParamsModel(
      order: OrderModel.fromMap(map['order']),
      orderItems: List<OrderItemModel>.from(map['orderItems']?.map((x) => OrderItemModel.fromMap(x))),
    );
  }

  factory OrderWithItemsParamsModel.fromJson(String source) => OrderWithItemsParamsModel.fromMap(json.decode(source));
  final OrderModel order;
  final List<OrderItemModel> orderItems;

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
