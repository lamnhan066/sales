import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/page_configurations_repository.dart';

class ChangeItemPerPageUseCase implements UseCase<void, int> {
  final PageConfigurationsRepository _repository;

  const ChangeItemPerPageUseCase(this._repository);

  @override
  Future<void> call(int params) {
    return _repository.setItemPerPage(params);
  }
}
