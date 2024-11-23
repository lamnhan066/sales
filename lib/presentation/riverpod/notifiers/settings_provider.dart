import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/usecases/app/change_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/app/get_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/backup_restore/backup_database_usecase.dart';
import 'package:sales/domain/usecases/backup_restore/restore_database_usecase.dart';
import 'package:sales/domain/usecases/categories/add_all_categories_usecase.dart';
import 'package:sales/domain/usecases/categories/get_all_categories.dart';
import 'package:sales/domain/usecases/data_services/remove_all_database_usecase.dart';
import 'package:sales/domain/usecases/discount/add_all_discounts_usecase.dart';
import 'package:sales/domain/usecases/discount/get_all_discounts_usecase.dart';
import 'package:sales/domain/usecases/last_view/get_save_last_view_usecase.dart';
import 'package:sales/domain/usecases/last_view/set_save_last_view_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/add_all_orders_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_all_orders_with_items_usecase.dart';
import 'package:sales/domain/usecases/products/add_all_products_usecase.dart';
import 'package:sales/domain/usecases/products/get_all_products_usecase.dart';
import 'package:sales/presentation/riverpod/states/settings_state.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(
    getItemPerPageUseCase: getIt(),
    changeItemPerPageUseCase: getIt(),
    backupDatabaseUseCase: getIt(),
    restoreDatabaseUseCase: getIt(),
    getAllProductsUseCase: getIt(),
    getAllCategoriesUsecCase: getIt(),
    getAllOrdersWithItemsUseCase: getIt(),
    addAllCategoriesUseCase: getIt(),
    addAllProductsUseCase: getIt(),
    addAllOrdersWithItemsUseCase: getIt(),
    getSaveLastViewUsecase: getIt(),
    setSaveLastViewUseCase: getIt(),
    getAllDiscountsUseCase: getIt(),
    addAllDiscountsUseCase: getIt(),
    removeAllDatabaseUseCase: getIt(),
  );
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier({
    required ChangeItemPerPageUseCase changeItemPerPageUseCase,
    required GetItemPerPageUseCase getItemPerPageUseCase,
    required BackupDatabaseUseCase backupDatabaseUseCase,
    required RestoreDatabaseUseCase restoreDatabaseUseCase,
    required GetAllProductsUseCase getAllProductsUseCase,
    required GetAllCategoriesUsecCase getAllCategoriesUsecCase,
    required GetAllOrdersWithItemsUseCase getAllOrdersWithItemsUseCase,
    required AddAllCategoriesUseCase addAllCategoriesUseCase,
    required AddAllProductsUseCase addAllProductsUseCase,
    required AddAllOrdersWithItemsUseCase addAllOrdersWithItemsUseCase,
    required GetSaveLastViewUsecase getSaveLastViewUsecase,
    required SetSaveLastViewUseCase setSaveLastViewUseCase,
    required GetAllDiscountsUseCase getAllDiscountsUseCase,
    required AddAllDiscountsUseCase addAllDiscountsUseCase,
    required RemoveAllDatabaseUseCase removeAllDatabaseUseCase,
  })  : _removeAllDatabaseUseCase = removeAllDatabaseUseCase,
        _addAllDiscountsUseCase = addAllDiscountsUseCase,
        _getAllDiscountsUseCase = getAllDiscountsUseCase,
        _setSaveLastViewUseCase = setSaveLastViewUseCase,
        _getSaveLastViewUsecase = getSaveLastViewUsecase,
        _addAllOrdersWithItemsUseCase = addAllOrdersWithItemsUseCase,
        _addAllProductsUseCase = addAllProductsUseCase,
        _addAllCategoriesUseCase = addAllCategoriesUseCase,
        _getAllOrdersWithItemsUseCase = getAllOrdersWithItemsUseCase,
        _getAllCategoriesUsecCase = getAllCategoriesUsecCase,
        _getAllProductsUseCase = getAllProductsUseCase,
        _restoreDatabaseUseCase = restoreDatabaseUseCase,
        _backupDatabaseUseCase = backupDatabaseUseCase,
        _getItemPerPageUseCase = getItemPerPageUseCase,
        _changeItemPerPageUseCase = changeItemPerPageUseCase,
        super(SettingsState()) {
    initialize();
  }
  final ChangeItemPerPageUseCase _changeItemPerPageUseCase;
  final GetItemPerPageUseCase _getItemPerPageUseCase;
  final BackupDatabaseUseCase _backupDatabaseUseCase;
  final RestoreDatabaseUseCase _restoreDatabaseUseCase;
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetAllCategoriesUsecCase _getAllCategoriesUsecCase;
  final GetAllOrdersWithItemsUseCase _getAllOrdersWithItemsUseCase;
  final AddAllCategoriesUseCase _addAllCategoriesUseCase;
  final AddAllProductsUseCase _addAllProductsUseCase;
  final AddAllOrdersWithItemsUseCase _addAllOrdersWithItemsUseCase;
  final GetSaveLastViewUsecase _getSaveLastViewUsecase;
  final SetSaveLastViewUseCase _setSaveLastViewUseCase;
  final GetAllDiscountsUseCase _getAllDiscountsUseCase;
  final AddAllDiscountsUseCase _addAllDiscountsUseCase;
  final RemoveAllDatabaseUseCase _removeAllDatabaseUseCase;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    final itemPerPage = await _getItemPerPageUseCase(NoParams());
    final saveLastView = await _getSaveLastViewUsecase(NoParams());

    state = state.copyWith(
      itemPerPage: itemPerPage,
      saveLastView: saveLastView,
      isLoading: false,
    );
  }

  Future<void> updateItemPerPage(int value) async {
    if (value <= 0) return;

    state = state.copyWith(itemPerPage: value);
    await _changeItemPerPageUseCase(value);
  }

  Future<void> toggleSaveLastView() async {
    final lastView = !state.saveLastView;
    state = state.copyWith(saveLastView: lastView);
    await _setSaveLastViewUseCase(lastView);
  }

  Future<int> getItemPerPage() async {
    return _getItemPerPageUseCase(NoParams());
  }

  Future<void> backup() async {
    try {
      state = state.copyWith(backupRestoreStatus: 'Đang chuẩn bị dữ liệu...'.tr);
      final products = await _getAllProductsUseCase(NoParams());
      final categories = await _getAllCategoriesUsecCase(NoParams());
      final ordersWithItems = await _getAllOrdersWithItemsUseCase(NoParams());
      final discounts = await _getAllDiscountsUseCase(NoParams());

      state = state.copyWith(backupRestoreStatus: 'Chọn vị trí lưu và lưu bản sao lưu...'.tr);
      final data = BackupData(
        categories: categories,
        products: products,
        orderWithItems: ordersWithItems,
        discounts: discounts,
      );

      final file = await _backupDatabaseUseCase(data);

      state = state.copyWith(backupRestoreStatus: '${'Sao lưu đã hoàn tất tại'.tr}\n${file.path}');
    } on Failure catch (e) {
      state = state.copyWith(backupRestoreStatus: e.message);
    }
  }

  Future<void> restore() async {
    try {
      state = state.copyWith(backupRestoreStatus: 'Đang lấy dữ liệu đã sao lưu...'.tr);
      final data = await _restoreDatabaseUseCase(NoParams());

      state = state.copyWith(backupRestoreStatus: 'Xoá tất cả dữ liệu hiện tại...'.tr);
      await _removeAllDatabaseUseCase(NoParams());

      state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Loại Hàng...'.tr);
      await _addAllCategoriesUseCase(data.categories);

      state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Sản Phẩm...'.tr);
      await _addAllProductsUseCase(data.products);

      state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Đơn Hàng và Chi Tiết Đơn hàng...'.tr);
      await _addAllOrdersWithItemsUseCase(data.orderWithItems);

      state = state.copyWith(backupRestoreStatus: 'Đang tiếm hành khôi phục Khuyến Mãi'.tr);
      await _addAllDiscountsUseCase(data.discounts);

      state = state.copyWith(backupRestoreStatus: 'Khôi phục đã hoàn tất'.tr);
    } on Failure catch (e) {
      state = state.copyWith(backupRestoreStatus: e.message);
    }
  }
}
