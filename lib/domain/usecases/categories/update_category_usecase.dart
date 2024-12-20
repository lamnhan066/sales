import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class UpdateCategoryUseCase implements UseCase<void, Category> {

  const UpdateCategoryUseCase(this._repository);
  final CategoryRepository _repository;

  @override
  Future<void> call(Category category) {
    return _repository.removeCategory(category);
  }
}
