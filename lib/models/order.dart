import 'dart:convert';

import 'package:sales/models/order_status.dart';

class Order {
  final int id;
  final OrderStatus status;
  final DateTime date;
  final bool deleted;

  Order({
    required this.id,
    required this.status,
    required this.date,
    this.deleted = false,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.name,
      'date': date.millisecondsSinceEpoch,
      'deleted': deleted,
    };
  }

  Map<String, dynamic> toSqlMap() {
    return {
      'o_id': id,
      'o_status': status.name,
      'o_date': date,
      'o_deleted': deleted,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      status: OrderStatus.values.byName(map['status']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      deleted: map['deleted'] ?? false,
    );
  }

  factory Order.fromSqlMap(Map<String, dynamic> map) {
    return Order(
      id: map['o_id']?.toInt() ?? 0,
      status: OrderStatus.values.byName(map['o_status']),
      date: DateTime.parse(map['o_date']),
      deleted: map['o_deleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
