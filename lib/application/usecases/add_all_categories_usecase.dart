import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class AddAllCategoriesUseCase implements UseCase<void, List<Category>> {
  final CategoryRepository _categoryRepository;

  const AddAllCategoriesUseCase(this._categoryRepository);

  @override
  Future<void> call(List<Category> categories) {
    return _categoryRepository.addAllCategories(categories);
  }
}
