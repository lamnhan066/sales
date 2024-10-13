import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/page_configurations_repository.dart';

class GetItemPerPageUseCase implements UseCase<int, NoParams> {
  final PageConfigurationsRepository _repository;

  const GetItemPerPageUseCase(this._repository);

  @override
  Future<int> call(NoParams params) {
    return _repository.getItemPerPage();
  }
}
