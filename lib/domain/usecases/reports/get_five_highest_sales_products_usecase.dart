import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetFiveHighestSalesProductsUseCase implements UseCase<Map<Product, int>, NoParams> {
  final ReportRepository _repository;

  const GetFiveHighestSalesProductsUseCase(this._repository);

  @override
  Future<Map<Product, int>> call(params) async {
    return await _repository.getFiveHighestSalesProducts();
  }
}
