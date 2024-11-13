import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/product.dart';

class RecentOrdersResult with EquatableMixin {

  const RecentOrdersResult({
    this.orderItems = const {},
    this.products = const {},
  });
  final Map<Order, List<OrderItem>> orderItems;
  final Map<Order, List<Product>> products;

  @override
  String toString() => 'RecentOrdersResult(orderItems: $orderItems, products: $products)';

  @override
  List<Object> get props => [orderItems, products];
}
