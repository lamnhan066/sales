import 'package:language_helper/language_helper.dart';

class PriceUtils {
  /// Chuyển khoảng giá sang dạng chữ.
  ///
  /// Với giá là infinity thì chữ sẽ trả về `Tối đa`.
  static String getPriceRangeText(double price) {
    if (price == double.infinity) {
      return 'Tối đa'.tr;
    }

    return '${price.toInt()}';
  }

  /// Tính toán tổng giá trị sản phẩm.
  static calcTotalPrice(int importPrice, int unitSalePrice, int quantity) {
    return importPrice * quantity;
  }
}
