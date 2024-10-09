import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/infrastucture/database/mappers/order_mapper_extension.dart';
import 'package:sales/infrastucture/database/models/order_model.dart';

extension GetResultOrderModel on GetResult<OrderModel> {
  GetResult<Order> toDomain() {
    return GetResult(totalCount: totalCount, items: items.map((e) => e.toDomain()).toList());
  }
}

extension GetResultOrderEntity on GetResult<Order> {
  GetResult<OrderModel> toDomain() {
    return GetResult(totalCount: totalCount, items: items.map((e) => e.toData()).toList());
  }
}
