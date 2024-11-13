import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetFiveLowStockProductsUseCase implements UseCase<List<Product>, NoParams> {

  const GetFiveLowStockProductsUseCase(this._repository);
  final ReportRepository _repository;

  @override
  Future<List<Product>> call(NoParams params) async {
    return _repository.getFiveLowStockProducts();
  }
}
