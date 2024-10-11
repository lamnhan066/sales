import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetFiveLowStockProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ReportRepository _repository;

  const GetFiveLowStockProductsUseCase(this._repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await _repository.getFiveLowStockProducts();
  }
}
