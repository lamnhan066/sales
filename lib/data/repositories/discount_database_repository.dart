import 'package:sales/data/models/discount_model.dart';
import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/pagination_params.dart';

abstract interface class DiscountDatabaseRepository {
  /// Lấy mã giảm giá theo mã.
  Future<DiscountModel?> getDiscountByCode(String code);

  /// Lây mã giảm giá theo order id.
  Future<List<DiscountModel>> getDiscountByOrderid(int id);

  /// Lấy tất cả mã giảm giá.
  Future<List<DiscountModel>> getAllDiscounts();

  /// Lưu tất cả mã giảm giá.
  Future<void> addAllDiscounts(List<DiscountModel> discounts);

  /// Thêm mã giảm giá.
  Future<void> addDiscountPercent(AddDiscountParams params);

  /// Cập nhật mã giảm giá.
  Future<void> updateDiscount(DiscountModel discount);

  /// Xoá mã giảm giá.
  Future<void> removeUnusedDiscount(DiscountModel data);

  /// Lấy tất cả mã giảm giá chưa được sử dụng.
  Future<GetResult<DiscountModel>> getAllAvailableDiscounts(PaginationParams params);
}
