import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/last_view_repository.dart';

class GetSaveLastViewUsecase implements UseCase<bool, NoParams> {

  const GetSaveLastViewUsecase(this._repository);
  final LastViewRepository _repository;

  @override
  Future<bool> call(NoParams params) {
    return _repository.getSaveLastViewState();
  }
}
