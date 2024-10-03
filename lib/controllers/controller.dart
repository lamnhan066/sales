/// Abstract cho các Controller.
abstract class Controller {
  /// Khởi tạo.
  Future<void> initial(void Function(void Function()) setState);

  /// Giải phóng.
  Future<void> dispose();
}
