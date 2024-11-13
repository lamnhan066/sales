import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetDailyOrderCountUseCase implements UseCase<int, DateTime> {

  const GetDailyOrderCountUseCase(this._repository);
  final ReportRepository _repository;

  @override
  Future<int> call(DateTime dateTime) async {
    return _repository.getDailyOrderCount(dateTime);
  }
}
