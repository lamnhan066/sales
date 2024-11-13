import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetFiveHighestSalesProductsUseCase implements UseCase<Map<Product, int>, NoParams> {

  const GetFiveHighestSalesProductsUseCase(this._repository);
  final ReportRepository _repository;

  @override
  Future<Map<Product, int>> call(NoParams params) async {
    return _repository.getFiveHighestSalesProducts();
  }
}
