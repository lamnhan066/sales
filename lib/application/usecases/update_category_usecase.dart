import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/category_repository.dart';
import 'package:sales/models/category.dart';

class UpdateCategoryUseCase implements UseCase<void, Category> {
  final CategoryRepository _repository;

  const UpdateCategoryUseCase(this._repository);

  @override
  Future<void> call(Category category) {
    return _repository.removeCategory(category);
  }
}
