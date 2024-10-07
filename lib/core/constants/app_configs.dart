/// Kiểu dữ liệu của hàm `setState`.
typedef SetState = void Function(void Function());

/// Các cấu hình thường dùng trong ứng dụng.
class AppConfigs {
  /// Chiều rộng nhỏ nhất của Dialog.
  static const double dialogMinWidth = 280;

  /// Tỉ lệ chiều rộng của Dialog so với màn hình.
  static const double dialogWidthRatio = 3 / 5;

  /// Chiều cao của thanh tìm kiếm, lọc.
  static const toolbarHeight = 56.0;
}
