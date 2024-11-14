import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/pagination_params.dart';

abstract interface class DiscountRepository {
  /// Lấy mã giảm giá theo mã.
  Future<Discount?> getDiscountByCode(String code);

  /// Lấy mã giảm giá theo mã.
  Future<List<Discount>> getDiscountsByOrderId(int id);

  /// Lấy tất cả mã giảm giá chưa được sử dụng.
  Future<GetResult<Discount>> getAllAvailableDiscounts(PaginationParams params);

  /// Lấy tất cả mã giảm giá.
  Future<List<Discount>> getAllDiscounts();

  /// Lưu tất cả mã giảm giá.
  Future<void> addAllDiscounts(List<Discount> discounts);

  /// Thêm mã giảm giá.
  Future<void> addDiscountPercent(AddDiscountParams params);

  /// Cập nhật mã giảm giá.
  Future<void> updateDiscount(Discount discount);

  /// Xoá mã giảm giá chưa được sử dụng.
  Future<void> removeUnusedDiscount(Discount discount);
}
