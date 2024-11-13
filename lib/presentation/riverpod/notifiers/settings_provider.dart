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
  );
});

class SettingsNotifier extends StateNotifier<SettingsState> {

  SettingsNotifier({
    required this.changeItemPerPageUseCase,
    required this.getItemPerPageUseCase,
    required this.backupDatabaseUseCase,
    required this.restoreDatabaseUseCase,
    required this.getAllProductsUseCase,
    required this.getAllCategoriesUsecCase,
    required this.getAllOrdersWithItemsUseCase,
    required this.addAllCategoriesUseCase,
    required this.addAllProductsUseCase,
    required this.addAllOrdersWithItemsUseCase,
    required this.getSaveLastViewUsecase,
    required this.setSaveLastViewUseCase,
  }) : super(SettingsState()) {
    initialize();
  }
  final ChangeItemPerPageUseCase changeItemPerPageUseCase;
  final GetItemPerPageUseCase getItemPerPageUseCase;
  final BackupDatabaseUseCase backupDatabaseUseCase;
  final RestoreDatabaseUseCase restoreDatabaseUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetAllCategoriesUsecCase getAllCategoriesUsecCase;
  final GetAllOrdersWithItemsUseCase getAllOrdersWithItemsUseCase;
  final AddAllCategoriesUseCase addAllCategoriesUseCase;
  final AddAllProductsUseCase addAllProductsUseCase;
  final AddAllOrdersWithItemsUseCase addAllOrdersWithItemsUseCase;
  final GetSaveLastViewUsecase getSaveLastViewUsecase;
  final SetSaveLastViewUseCase setSaveLastViewUseCase;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    final itemPerPage = await getItemPerPageUseCase(NoParams());
    final saveLastView = await getSaveLastViewUsecase(NoParams());

    state = state.copyWith(
      itemPerPage: itemPerPage,
      saveLastView: saveLastView,
      isLoading: false,
    );
  }

  Future<void> updateItemPerPage(int value) async {
    if (value <= 0) return;

    state = state.copyWith(itemPerPage: value);
    await changeItemPerPageUseCase(value);
  }

  Future<void> toggleSaveLastView() async {
    final lastView = !state.saveLastView;
    state = state.copyWith(saveLastView: lastView);
    await setSaveLastViewUseCase(lastView);
  }

  Future<int> getItemPerPage() async {
    return getItemPerPageUseCase(NoParams());
  }

  Future<void> backup() async {
    try {
      state = state.copyWith(backupRestoreStatus: 'Đang chuẩn bị dữ liệu...'.tr);
      final products = await getAllProductsUseCase(NoParams());
      final categories = await getAllCategoriesUsecCase(NoParams());
      final ordersWithItems = await getAllOrdersWithItemsUseCase(NoParams());

      state = state.copyWith(backupRestoreStatus: 'Chọn vị trí lưu và lưu bản sao lưu...'.tr);
      final data = BackupData(
        categories: categories,
        products: products,
        orderWithItems: ordersWithItems,
      );

      await backupDatabaseUseCase(data);

      state = state.copyWith(backupRestoreStatus: 'Sao lưu đã hoàn tất tại'.tr);
    } on Failure catch (e) {
      state = state.copyWith(backupRestoreStatus: e.message);
    }
  }

  Future<void> restore() async {
    try {
      state = state.copyWith(backupRestoreStatus: 'Đang lấy dữ liệu đã sao lưu...'.tr);
      final data = await restoreDatabaseUseCase(NoParams());

      state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Loại Hàng...'.tr);
      await addAllCategoriesUseCase(data.categories);

      state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Sản Phẩm...'.tr);
      await addAllProductsUseCase(data.products);

      state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Đơn Hàng và Chi Tiết Đơn hàng...'.tr);
      await addAllOrdersWithItemsUseCase(data.orderWithItems);

      state = state.copyWith(backupRestoreStatus: 'Khôi phục đã hoàn tất'.tr);
    } on Failure catch (e) {
      state = state.copyWith(backupRestoreStatus: e.message);
    }
  }
}
