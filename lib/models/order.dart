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
}
