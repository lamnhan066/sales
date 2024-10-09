import 'package:equatable/equatable.dart';

class OrderWithItemsParams<O extends Object, T> with EquatableMixin {
  final O order;
  final List<T> orderItems;

  OrderWithItemsParams({
    required this.order,
    required this.orderItems,
  });

  @override
  List<Object> get props => [order, orderItems];
}
