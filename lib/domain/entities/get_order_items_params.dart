import 'package:equatable/equatable.dart';

class GetOrderItemsParams with EquatableMixin {
  final int? orderId;
  final int? productId;

  const GetOrderItemsParams({
    this.orderId,
    this.productId,
  });

  @override
  List<Object?> get props => [orderId, productId];
}
