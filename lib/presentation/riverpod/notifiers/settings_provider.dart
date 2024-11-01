import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/usecases/app/change_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/app/change_language_usecase.dart';
import 'package:sales/domain/usecases/app/get_current_brightness_usecase.dart';
import 'package:sales/domain/usecases/app/get_current_language_usecase.dart';
import 'package:sales/domain/usecases/app/get_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/app/get_supported_languages_usecase.dart';
import 'package:sales/domain/usecases/app/set_brightness_usecase.dart';
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
    getCurrentLanguageUseCase: getIt(),
    getSupportedLanguagesUseCase: getIt(),
    changeLanguageUseCase: getIt(),
    getItemPerPageUseCase: getIt(),
    changeItemPerPageUseCase: getIt(),
    getCurrentBrightnessUseCase: getIt(),
    setBrightnessUseCase: getIt(),
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
  final GetCurrentLanguageUseCase getCurrentLanguageUseCase;
  final GetSupportedLanguagesUseCase getSupportedLanguagesUseCase;
  final ChangeLanguageUseCase changeLanguageUseCase;
  final ChangeItemPerPageUseCase changeItemPerPageUseCase;
  final GetItemPerPageUseCase getItemPerPageUseCase;
  final GetCurrentBrightnessUseCase getCurrentBrightnessUseCase;
  final SetBrightnessUseCase setBrightnessUseCase;
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

  SettingsNotifier({
    required this.getCurrentLanguageUseCase,
    required this.getSupportedLanguagesUseCase,
    required this.changeLanguageUseCase,
    required this.changeItemPerPageUseCase,
    required this.getItemPerPageUseCase,
    required this.getCurrentBrightnessUseCase,
    required this.setBrightnessUseCase,
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

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    final currentLanguage = await getCurrentLanguageUseCase(NoParams());
    final supportedLanguages = await getSupportedLanguagesUseCase(NoParams());
    final itemPerPage = await getItemPerPageUseCase(NoParams());
    final brightness = await getCurrentBrightnessUseCase(NoParams());
    final saveLastView = await getSaveLastViewUsecase(NoParams());

    state = state.copyWith(
      currentlanguage: currentLanguage,
      supportedLanguages: supportedLanguages,
      itemPerPage: itemPerPage,
      brightness: brightness,
      saveLastView: saveLastView,
      isLoading: false,
    );
  }

  Future<LanguageCodes> getCurrentLanguage() {
    return getCurrentLanguageUseCase(NoParams());
  }

  Future<Set<LanguageCodes>> getSupportedLanguages() async {
    return getSupportedLanguagesUseCase(NoParams());
  }

  Future<void> changeLanguage(LanguageCodes code) async {
    state = state.copyWith(currentlanguage: code);
    await changeLanguageUseCase(code);
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

  Future<Brightness> getCurrentBrightness() {
    return getCurrentBrightnessUseCase(NoParams());
  }

  Future<void> setBrightness(Brightness brightness) async {
    state = state.copyWith(brightness: brightness);
    await setBrightnessUseCase(brightness);
  }

  Future<void> backup() async {
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

    try {
      await backupDatabaseUseCase(data);

      state = state.copyWith(backupRestoreStatus: 'Sao lưu đã hoàn tất tại'.tr);
    } on Failure catch (e) {
      state = state.copyWith(backupRestoreStatus: e.message);
    }
  }

  Future<void> restore() async {
    state = state.copyWith(backupRestoreStatus: 'Đang lấy dữ liệu đã sao lưu...'.tr);
    final data = await restoreDatabaseUseCase(NoParams());

    state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Loại Hàng...'.tr);
    await addAllCategoriesUseCase(data.categories);

    state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Sản Phẩm...'.tr);
    await addAllProductsUseCase(data.products);

    state = state.copyWith(backupRestoreStatus: 'Đang tiến hành khôi phục Đơn Hàng và Chi Tiết Đơn hàng...'.tr);
    await addAllOrdersWithItemsUseCase(data.orderWithItems);

    state = state.copyWith(backupRestoreStatus: 'Khôi phục đã hoàn tất'.tr);
  }
}
