abstract interface class CoreDatabaseRepository {
  /// Khởi tạo.
  Future<void> initial();

  /// Giải phóng.
  Future<void> dispose();

  /// Xoá hết toàn bộ dữ liệu.
  Future<void> clear();
}
