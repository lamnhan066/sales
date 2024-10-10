import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class GetNextCategoryIdUseCase implements UseCase<int, NoParams> {
  final CategoryRepository _categoryRepository;

  GetNextCategoryIdUseCase(this._categoryRepository);

  @override
  Future<int> call(NoParams params) {
    return _categoryRepository.getNextCategoryId();
  }
}
