import 'package:language_helper/language_helper.dart';

/// Trạng thái đơn hàng.
enum OrderStatus {
  /// Đã tạo.
  created,

  /// Đã thanh toán.
  paid,

  /// Đã huỷ.
  cancelled;

  String get text {
    return switch (this) {
      OrderStatus.created => 'Đã tạo'.tr,
      OrderStatus.paid => 'Đã thanh toán'.tr,
      OrderStatus.cancelled => 'Đã huỷ'.tr,
    };
  }
}
