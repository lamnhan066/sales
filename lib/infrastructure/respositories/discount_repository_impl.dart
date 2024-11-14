import 'package:sales/data/mappers/discount_mapper_extension.dart';
import 'package:sales/data/repositories/discount_database_repository.dart';
import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/pagination_params.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class DiscountRepositoryImpl implements DiscountRepository {
  const DiscountRepositoryImpl(this._repository);

  final DiscountDatabaseRepository _repository;

  @override
  Future<GetResult<Discount>> getAllAvailableDiscounts(PaginationParams params) async {
    final result = await _repository.getAllAvailableDiscounts(params);
    return GetResult(totalCount: result.totalCount, items: result.items.map((e) => e.toDomain()).toList());
  }

  @override
  Future<List<Discount>> getAllDiscounts() async {
    final result = await _repository.getAllDiscounts();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> addAllDiscounts(List<Discount> discounts) async {
    await _repository.addAllDiscounts(discounts.map((e) => e.toData()).toList());
  }

  @override
  Future<Discount?> getDiscountByCode(String code) async {
    final discount = await _repository.getDiscountByCode(code);
    return discount?.toDomain();
  }

  @override
  Future<List<Discount>> getDiscountsByOrderId(int id) async {
    final discount = await _repository.getDiscountByOrderid(id);
    return discount.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> addDiscountPercent(AddDiscountParams params) async {
    await _repository.addDiscountPercent(params);
  }

  @override
  Future<void> updateDiscount(Discount discount) async {
    await _repository.updateDiscount(discount.toData());
  }

  @override
  Future<void> removeUnusedDiscount(Discount discount) async {
    await _repository.removeUnusedDiscount(discount.toData());
  }
}
