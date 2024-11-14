import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/pagination_params.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class GetAllAvailableDiscountsUseCase implements UseCase<GetResult<Discount>, PaginationParams> {
  const GetAllAvailableDiscountsUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<GetResult<Discount>> call(PaginationParams params) {
    return _repository.getAllAvailableDiscounts(params);
  }
}
