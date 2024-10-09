import 'package:sales/data/mappers/order_item_mapper_extension.dart';
import 'package:sales/data/mappers/order_mapper_extension.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

extension OrderWithItemsParamsExtension on OrderWithItemsParams<Order, OrderItem> {
  OrderWithItemsParams<OrderModel, OrderItemModel> toData() {
    return OrderWithItemsParams(
      order: order.toData(),
      orderItems: orderItems.map((e) => e.toData()).toList(),
    );
  }
}
