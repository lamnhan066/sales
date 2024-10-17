import 'package:intl/intl.dart';

extension PriceFromIntExtension on int {
  String toPriceDigit() {
    return NumberFormat('#,###').format(this);
  }
}

extension PriceToIntExtension on String {
  int priceToInt() {
    return NumberFormat('#,###').parse(this).round();
  }
}
