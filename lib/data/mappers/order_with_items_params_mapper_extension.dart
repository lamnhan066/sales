import 'package:sales/data/mappers/order_item_mapper_extension.dart';
import 'package:sales/data/mappers/order_mapper_extension.dart';
import 'package:sales/data/models/order_with_items_model.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

extension OrderWithItemsParamsExtension on OrderWithItemsParams {
  OrderWithItemsParamsModel toData() {
    return OrderWithItemsParamsModel(
      order: order.toData(),
      orderItems: orderItems.map((e) => e.toData()).toList(),
    );
  }
}

extension OrderWithItemsParamsModelExtension on OrderWithItemsParamsModel {
  OrderWithItemsParams toDomain() {
    return OrderWithItemsParams(
      order: order.toDomain(),
      orderItems: orderItems.map((e) => e.toDomain()).toList(),
    );
  }
}
