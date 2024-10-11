import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetDailyOrderCountUseCase implements UseCase<int, DateTime> {
  final ReportRepository _repository;

  const GetDailyOrderCountUseCase(this._repository);

  @override
  Future<int> call(DateTime dateTime) async {
    return await _repository.getDailyOrderCount(dateTime);
  }
}
