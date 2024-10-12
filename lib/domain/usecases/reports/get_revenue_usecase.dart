import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetRevenueUseCase implements UseCase<int, Ranges<DateTime>> {
  final ReportRepository _repository;

  const GetRevenueUseCase(this._repository);

  @override
  Future<int> call(Ranges<DateTime> params) {
    return _repository.getRevenuue(params);
  }
}
