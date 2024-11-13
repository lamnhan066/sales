import 'package:equatable/equatable.dart';

class GetOrderItemsParams with EquatableMixin {

  const GetOrderItemsParams({
    this.orderId,
    this.productId,
  });
  final int? orderId;
  final int? productId;

  @override
  List<Object?> get props => [orderId, productId];
}
