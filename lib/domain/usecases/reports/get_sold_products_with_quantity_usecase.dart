import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetSoldProductsWithQuantityUsecase implements UseCase<Map<Product, int>, Ranges<DateTime>> {
  final ReportRepository _repository;

  const GetSoldProductsWithQuantityUsecase(this._repository);

  @override
  Future<Map<Product, int>> call(Ranges<DateTime> params) {
    return _repository.getSoldProductsWithQuantity(params);
  }
}
