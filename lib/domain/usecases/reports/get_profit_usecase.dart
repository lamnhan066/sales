import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetProfitUseCase implements UseCase<int, Ranges<DateTime>> {
  final ReportRepository _repository;

  const GetProfitUseCase(this._repository);

  @override
  Future<int> call(Ranges<DateTime> params) {
    return _repository.getProfit(params);
  }
}
