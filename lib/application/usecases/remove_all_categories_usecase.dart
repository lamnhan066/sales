import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class RemoveAllCategoriesUseCase implements UseCase<void, NoParams> {
  final CategoryRepository _repository;

  const RemoveAllCategoriesUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.removeAllCategories();
  }
}
