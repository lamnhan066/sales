import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/infrastucture/database/mappers/order_item_mapper_extension.dart';
import 'package:sales/infrastucture/database/mappers/order_mapper_extension.dart';
import 'package:sales/infrastucture/database/mappers/product_mapper_extension.dart';
import 'package:sales/infrastucture/database/models/get_orders_result_model.dart';

extension RecentOrderResultModelMapper on RecentOrdersResultModel {
  RecentOrdersResult toDomain() {
    return RecentOrdersResult(
      orderItems: orderItems.map((key, value) => MapEntry(key.toDomain(), value.map((e) => e.toDomain()).toList())),
      products: products.map((key, value) => MapEntry(key.toDomain(), value.map((e) => e.toDomain()).toList())),
    );
  }
}
