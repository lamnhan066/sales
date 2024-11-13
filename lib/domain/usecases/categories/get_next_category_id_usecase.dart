import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class GetNextCategoryIdUseCase implements UseCase<int, NoParams> {

  GetNextCategoryIdUseCase(this._categoryRepository);
  final CategoryRepository _categoryRepository;

  @override
  Future<int> call(NoParams params) {
    return _categoryRepository.getNextCategoryId();
  }
}
