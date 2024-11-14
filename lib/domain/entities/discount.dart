import 'dart:convert';

import 'package:equatable/equatable.dart';

class Discount with EquatableMixin {
  Discount({
    required this.id,
    required this.orderId,
    required this.code,
    required this.percent,
    required this.maxPrice,
  });

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id']?.toInt() ?? 0,
      orderId: map['orderId']?.toInt() ?? -1,
      code: map['code'] ?? '',
      percent: map['percent']?.toInt() ?? 0,
      maxPrice: map['maxPrice']?.toInt() ?? 0,
    );
  }

  factory Discount.fromJson(String source) => Discount.fromMap(json.decode(source));

  final int id;
  final int orderId;
  final String code;
  final int percent;
  final int maxPrice;

  bool get hasOwnedOrder => orderId != -1;
  bool get hasMaxPrice => maxPrice > 0;

  int calculate(int price) {
    if (price == 0) return price;

    final calculated = (percent / 100 * price).round();
    if (hasMaxPrice && calculated > maxPrice) {
      return price - maxPrice;
    }

    return price - calculated;
  }

  Discount copyWith({
    int? id,
    int? orderId,
    String? code,
    int? percent,
    int? maxPrice,
  }) {
    return Discount(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      code: code ?? this.code,
      percent: percent ?? this.percent,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  Discount copyWithNoOrderId({
    int? id,
    String? code,
    int? percent,
    int? maxPrice,
  }) {
    return Discount(
      id: id ?? this.id,
      orderId: -1,
      code: code ?? this.code,
      percent: percent ?? this.percent,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'code': code,
      'percent': percent,
      'maxPrice': maxPrice,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object> get props {
    return [
      id,
      orderId,
      code,
      percent,
      maxPrice,
    ];
  }
}
