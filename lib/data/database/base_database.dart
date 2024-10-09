abstract interface class BaseDatabase {
  /// Khởi tạo.
  Future<void> initial();

  /// Giải phóng.
  Future<void> dispose();
}
