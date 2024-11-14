import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/data/repositories/discount_database_repository.dart';
import 'package:sales/domain/entities/discount.dart';

class GetDiscountByCodeUseCase implements UseCase<Discount?, String> {
  const GetDiscountByCodeUseCase(this._repository);

  final DiscountDatabaseRepository _repository;

  @override
  Future<Discount?> call(String params) {
    return _repository.getDiscountByCode(params);
  }
}
