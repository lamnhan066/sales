import 'dart:convert';

import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_status.dart';

/// Đơn hàng.
class OrderModel extends Order {
  /// Đơn hàng.
  OrderModel({
    required super.id,
    required super.status,
    required super.date,
    super.deleted = false,
  });

  /// SQL Map -> Order.
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: (map['o_id'] as num).toInt(),
      status: OrderStatus.values.byName((map['o_status'] as String).trim()),
      date: map['o_date'],
      deleted: map['o_deleted'] as bool,
    );
  }

  /// JSON -> Order
  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  @override
  OrderModel copyWith({
    int? id,
    OrderStatus? status,
    DateTime? date,
    bool? deleted,
  }) {
    return OrderModel(
      id: id ?? this.id,
      status: status ?? this.status,
      date: date ?? this.date,
      deleted: deleted ?? this.deleted,
    );
  }

  /// Order -> SQL Map
  @override
  Map<String, dynamic> toMap() {
    return {
      'o_id': id,
      'o_status': status.name,
      'o_date': date,
      'o_deleted': deleted,
    };
  }

  /// Order -> JSON
  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Order(id: $id, status: $status, date: $date, deleted: $deleted)';
  }
}
