import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetDailyRevenueUseCase implements UseCase<int, DateTime> {
  final ReportRepository _repository;

  const GetDailyRevenueUseCase(this._repository);

  @override
  Future<int> call(DateTime dateTime) async {
    return await _repository.getDailyRevenue(dateTime);
  }
}
