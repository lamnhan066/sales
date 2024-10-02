import 'package:language_helper/language_helper.dart';

enum OrderStatus {
  created,
  paid,
  cancelled;

  String get text {
    return switch (this) {
      OrderStatus.created => 'Đã tạo'.tr,
      OrderStatus.paid => 'Đã thanh toán'.tr,
      OrderStatus.cancelled => 'Đã huỷ'.tr,
    };
  }
}
