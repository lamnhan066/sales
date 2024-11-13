import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';

class OrderResult with EquatableMixin {

  OrderResult({
    required this.order,
    required this.orderItems,
  });
  final Order order;
  final List<OrderItem> orderItems;

  @override
  List<Object> get props => [order, orderItems];
}
