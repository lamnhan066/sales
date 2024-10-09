import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class GetAllCategoriesUsecCase implements UseCase<List<Category>, NoParams> {
  final CategoryRepository _repository;

  const GetAllCategoriesUsecCase(this._repository);

  @override
  Future<List<Category>> call(NoParams params) async {
    return _repository.getAllCategories();
  }
}
