import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/page_configurations_repository.dart';

class ChangeItemPerPageUseCase implements UseCase<void, int> {

  const ChangeItemPerPageUseCase(this._repository);
  final PageConfigurationsRepository _repository;

  @override
  Future<void> call(int params) {
    return _repository.setItemPerPage(params);
  }
}
