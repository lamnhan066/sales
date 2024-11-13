import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class AddAllCategoriesUseCase implements UseCase<void, List<Category>> {

  const AddAllCategoriesUseCase(this._categoryRepository);
  final CategoryRepository _categoryRepository;

  @override
  Future<void> call(List<Category> categories) {
    return _categoryRepository.addAllCategories(categories);
  }
}
