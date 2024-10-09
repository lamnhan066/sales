import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';

class OrderResult with EquatableMixin {
  final Order order;
  final List<OrderItem> orderItems;

  OrderResult({
    required this.order,
    required this.orderItems,
  });

  @override
  List<Object> get props => [order, orderItems];
}
