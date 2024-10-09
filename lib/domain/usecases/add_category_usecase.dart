import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class AddCategoryUseCase implements UseCase<void, Category> {
  final CategoryRepository _repository;

  const AddCategoryUseCase(this._repository);

  @override
  Future<void> call(Category category) {
    return _repository.addCategory(category);
  }
}
