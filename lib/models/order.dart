enum OrderStatus { created, paid, canceled }

class Order {
  final int id;
  final OrderStatus status;
  final DateTime date;
  final bool deleted;

  Order({
    required this.id,
    required this.status,
    required this.date,
    required this.deleted,
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
}
