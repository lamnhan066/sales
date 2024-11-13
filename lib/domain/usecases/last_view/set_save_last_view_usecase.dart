import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/last_view_repository.dart';

class SetSaveLastViewUseCase implements UseCase<void, bool> {

  const SetSaveLastViewUseCase(this._repository);
  final LastViewRepository _repository;

  @override
  Future<void> call(bool params) {
    return _repository.setSaveLastViewState(params);
  }
}
