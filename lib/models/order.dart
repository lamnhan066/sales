import 'dart:convert';

import 'package:sales/models/order_status.dart';

/// Đơn hàng.
class Order {
  /// Id.
  final int id;

  /// Trạng thái.
  final OrderStatus status;

  /// Ngày đặt hàng.
  final DateTime date;

  /// Đánh dấu xoá.
  final bool deleted;

  /// Đơn hàng.
  Order({
    required this.id,
    required this.status,
    required this.date,
    this.deleted = false,
  });

  /// Map -> Order.
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: (map['id'] as num?)?.toInt() ?? 0,
      status: OrderStatus.values.byName(map['status'] as String),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      deleted: map['deleted'] as bool,
    );
  }

  /// SQL Map -> Order.
  factory Order.fromSqlMap(Map<String, dynamic> map) {
    return Order(
      id: (map['o_id'] as num).toInt(),
      status: OrderStatus.values.byName(map['o_status'] as String),
      date: DateTime.parse(map['o_date'] as String),
      deleted: map['o_deleted'] as bool,
    );
  }

  /// JSON -> Order
  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  Order copyWith({
    int? id,
    OrderStatus? status,
    DateTime? date,
    bool? deleted,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      date: date ?? this.date,
      deleted: deleted ?? this.deleted,
    );
  }

  /// Order -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.name,
      'date': date.millisecondsSinceEpoch,
      'deleted': deleted,
    };
  }

  /// Order -> SQL Map
  Map<String, dynamic> toSqlMap() {
    return {
      'o_id': id,
      'o_status': status.name,
      'o_date': date,
      'o_deleted': deleted,
    };
  }

  /// Order -> JSON
  String toJson() => json.encode(toMap());
}
