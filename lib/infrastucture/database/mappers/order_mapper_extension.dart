import 'package:sales/domain/entities/order.dart';
import 'package:sales/infrastucture/database/models/order_model.dart';

extension OrderModelExtension on OrderModel {
  Order toDomain() {
    return Order(id: id, status: status, date: date);
  }
}

extension OrderEntityExtension on Order {
  OrderModel toData() {
    return OrderModel(id: id, status: status, date: date);
  }
}
