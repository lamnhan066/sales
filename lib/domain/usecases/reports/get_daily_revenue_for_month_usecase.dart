import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetDailyRevenueForMonth implements UseCase<List<int>, DateTime> {
  final ReportRepository _repository;

  const GetDailyRevenueForMonth(this._repository);

  @override
  Future<List<int>> call(DateTime dateTime) async {
    return await _repository.getDailyRevenueForMonth(dateTime);
  }
}
