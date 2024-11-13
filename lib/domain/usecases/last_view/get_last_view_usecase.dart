import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/views_model.dart';
import 'package:sales/domain/repositories/last_view_repository.dart';

class GetLastViewUseCase implements UseCase<ViewsModel, NoParams> {

  const GetLastViewUseCase(this._repository);
  final LastViewRepository _repository;

  @override
  Future<ViewsModel> call(NoParams params) {
    return _repository.getLastView();
  }
}
