import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetDailyRevenueForMonth implements UseCase<List<int>, DateTime> {

  const GetDailyRevenueForMonth(this._repository);
  final ReportRepository _repository;

  @override
  Future<List<int>> call(DateTime dateTime) async {
    return _repository.getDailyRevenueForMonth(dateTime);
  }
}
