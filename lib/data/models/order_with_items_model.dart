import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';

class OrderWithItemsParamsModel with EquatableMixin {
  final OrderModel order;
  final List<OrderItemModel> orderItems;

  OrderWithItemsParamsModel({
    required this.order,
    required this.orderItems,
  });

  @override
  List<Object> get props => [order, orderItems];

  Map<String, dynamic> toMap() {
    return {
      'order': order.toMap(),
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderWithItemsParamsModel.fromMap(Map<String, dynamic> map) {
    return OrderWithItemsParamsModel(
      order: OrderModel.fromMap(map['order']),
      orderItems: List<OrderItemModel>.from(map['orderItems']?.map((x) => OrderItemModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderWithItemsParamsModel.fromJson(String source) => OrderWithItemsParamsModel.fromMap(json.decode(source));
}
