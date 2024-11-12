abstract interface class CoreDatabase {
  /// Khởi tạo.
  Future<void> initial();

  /// Giải phóng.
  Future<void> dispose();
}
