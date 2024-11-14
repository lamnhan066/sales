import 'package:features_tour/features_tour.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/entities/pagination_params.dart';
import 'package:sales/domain/usecases/app/get_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/discount/add_discount_usecase.dart';
import 'package:sales/domain/usecases/discount/get_all_available_discounts_usecase.dart';
import 'package:sales/domain/usecases/discount/get_discount_by_code_usecase.dart';
import 'package:sales/domain/usecases/discount/update_discount_usecase.dart';
import 'package:sales/presentation/riverpod/states/discount_state.dart';

final discountProvider = StateNotifierProvider<DiscountNotifier, DiscountState>((ref) {
  return DiscountNotifier(
    getAllAvailableDiscountsUseCase: getIt(),
    getDiscountByCodeUseCase: getIt(),
    addDiscountUseCase: getIt(),
    updateDiscountUseCase: getIt(),
    getItemPerPageUseCase: getIt(),
  );
});

class DiscountNotifier extends StateNotifier<DiscountState> {
  DiscountNotifier({
    required this.getAllAvailableDiscountsUseCase,
    required this.getDiscountByCodeUseCase,
    required this.addDiscountUseCase,
    required this.updateDiscountUseCase,
    required this.getItemPerPageUseCase,
  }) : super(DiscountState(tour: FeaturesTourController('DiscountView')));

  final GetAllAvailableDiscountsUseCase getAllAvailableDiscountsUseCase;
  final GetDiscountByCodeUseCase getDiscountByCodeUseCase;
  final AddDiscountUseCase addDiscountUseCase;
  final UpdateDiscountUseCase updateDiscountUseCase;
  final GetItemPerPageUseCase getItemPerPageUseCase;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    final perPage = await getItemPerPageUseCase(NoParams());
    await fetch(resetPage: true);
    state = state.copyWith(perPage: perPage, isLoading: false);
  }

  Future<void> fetch({bool resetPage = false}) async {
    final perpage = await getItemPerPageUseCase(NoParams());
    var page = state.page;
    if (resetPage) page = 1;

    final discounts = await getAllAvailableDiscountsUseCase(
      PaginationParams(
        page: page,
        perpage: perpage,
      ),
    );
    state = state.copyWith(
      discounts: discounts.items,
      totalPage: (discounts.totalCount / perpage).ceil(),
    );
  }

  Future<void> goToPreviousPage() async {
    await goToPage(state.page - 1);
  }

  Future<void> goToNextPage() async {
    await goToPage(state.page + 1);
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > state.totalPage) return;

    state = state.copyWith(page: page);
    await fetch();
  }

  Future<Discount?> getDiscountByCode(String code) {
    return getDiscountByCodeUseCase(code);
  }

  Future<void> updateDiscount(Discount discount) async {
    await updateDiscountUseCase(discount);
    await fetch();
  }

  Future<void> addDiscountPercent(AddDiscountParams params) async {
    await addDiscountUseCase(params);
    await fetch();
  }

  Future<void> copyDiscount(Discount discount) async {
    await Clipboard.setData(ClipboardData(text: discount.code));
  }

  Future<void> removeDiscount(Discount discount) async {}
}
