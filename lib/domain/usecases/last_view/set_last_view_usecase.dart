import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/views_model.dart';
import 'package:sales/domain/repositories/last_view_repository.dart';

class SetLastViewUseCase implements UseCase<void, ViewsModel> {

  const SetLastViewUseCase(this._repository);
  final LastViewRepository _repository;

  @override
  Future<void> call(ViewsModel view) {
    return _repository.setLastView(view);
  }
}
