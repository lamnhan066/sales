import 'package:sales/data/mappers/order_mapper_extension.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';

extension GetResultOrderModel on GetResult<OrderModel> {
  GetResult<Order> toDomain() {
    return GetResult(totalCount: totalCount, items: items.map((e) => e.toDomain()).toList());
  }
}

extension GetResultOrderEntity on GetResult<Order> {
  GetResult<OrderModel> toData() {
    return GetResult(totalCount: totalCount, items: items.map((e) => e.toData()).toList());
  }
}
