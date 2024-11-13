import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class RemoveCategoryUseCase implements UseCase<void, Category> {

  const RemoveCategoryUseCase(this._repository);
  final CategoryRepository _repository;

  @override
  Future<void> call(Category category) {
    return _repository.removeCategory(category);
  }
}
