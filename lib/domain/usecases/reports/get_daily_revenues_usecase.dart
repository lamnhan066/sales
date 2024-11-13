import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetDailyRevenueUseCase implements UseCase<int, DateTime> {

  const GetDailyRevenueUseCase(this._repository);
  final ReportRepository _repository;

  @override
  Future<int> call(DateTime dateTime) async {
    return _repository.getDailyRevenue(dateTime);
  }
}
