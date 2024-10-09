import 'package:language_helper/language_helper.dart';

/// Utils
class Utils {
  /// DateTime -> hh:mm h dd/MM/yyyy
  static String formatDateTime(DateTime date) {
    String padLeft2(int number) {
      return '$number'.padLeft(2, '0');
    }

    final hour = padLeft2(date.hour);
    final minute = padLeft2(date.minute);
    final day = padLeft2(date.day);
    final month = padLeft2(date.month);

    return '${hour}h$minute $day/$month/${date.year}';
  }

  /// DateTime -> d/M/yyyy
  static String dateToSql(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  /// Chuyển khoảng giá sang dạng chữ.
  ///
  /// Với giá là infinity thì chữ sẽ trả về `Tối đa`.
  static String getPriceRangeText(double price) {
    if (price == double.infinity) {
      return 'Tối đa'.tr;
    }

    return '${price.toInt()}';
  }

  static calcTotalPrice(int importPrice, int unitSalePrice, int quantity) {
    return importPrice * quantity;
  }
}