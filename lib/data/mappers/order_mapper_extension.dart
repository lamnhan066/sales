import 'package:sales/data/models/order_model.dart';
import 'package:sales/domain/entities/order.dart';

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
