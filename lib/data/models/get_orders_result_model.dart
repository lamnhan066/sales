import 'package:equatable/equatable.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';

class RecentOrdersResultModel with EquatableMixin {

  const RecentOrdersResultModel({
    required this.orderItems,
    required this.products,
  });
  final Map<OrderModel, List<OrderItemModel>> orderItems;
  final Map<OrderModel, List<ProductModel>> products;

  @override
  List<Object> get props => [orderItems, products];

  @override
  String toString() => 'RecentOrdersResultModel(orderItems: $orderItems, products: $products)';
}
