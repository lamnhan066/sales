import 'package:sales/domain/entities/discount.dart';

class DiscountModel extends Discount {
  DiscountModel({
    required super.id,
    required super.orderId,
    required super.code,
    required super.percent,
    required super.maxPrice,
  });

  factory DiscountModel.fromMap(Map<String, dynamic> map) {
    return DiscountModel(
      id: map['dc_id'],
      code: map['dc_code'] ?? '',
      percent: map['dc_percent']?.toInt() ?? 0,
      maxPrice: map['dc_max_price']?.toInt() ?? 0,
      orderId: map['dc_order_id']?.toInt() ?? -1,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'dc_id': id,
      'dc_code': code,
      'dc_percent': percent,
      'dc_max_price': maxPrice,
      'dc_order_id': orderId,
    };
  }
}
