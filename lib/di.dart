import 'package:features_tour/features_tour.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/data/repositories/category_database_repository.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/data_sync_database_repository.dart';
import 'package:sales/data/repositories/discount_database_repository.dart';
import 'package:sales/data/repositories/order_database_repository.dart';
import 'package:sales/data/repositories/order_item_database_repository.dart';
import 'package:sales/data/repositories/order_with_items_database_repository.dart';
import 'package:sales/data/repositories/product_database_repository.dart';
import 'package:sales/data/repositories/report_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_category_impl.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/data/source/postgres/postgres_data_sync_impl.dart';
import 'package:sales/data/source/postgres/postgres_discount_impl.dart';
import 'package:sales/data/source/postgres/postgres_order_impl.dart';
import 'package:sales/data/source/postgres/postgres_order_item_impl.dart';
import 'package:sales/data/source/postgres/postgres_order_with_items_impl.dart';
import 'package:sales/data/source/postgres/postgres_product_impl.dart';
import 'package:sales/data/source/postgres/postgres_report_impl.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';
import 'package:sales/domain/repositories/brightness_repository.dart';
import 'package:sales/domain/repositories/category_repository.dart';
import 'package:sales/domain/repositories/data_importer_repository.dart';
import 'package:sales/domain/repositories/discount_repository.dart';
import 'package:sales/domain/repositories/language_repository.dart';
import 'package:sales/domain/repositories/last_view_repository.dart';
import 'package:sales/domain/repositories/license_repository.dart';
import 'package:sales/domain/repositories/order_item_repository.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';
import 'package:sales/domain/repositories/page_configurations_repository.dart';
import 'package:sales/domain/repositories/print_repository.dart';
import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/domain/repositories/report_repository.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';
import 'package:sales/domain/services/database_service.dart';
import 'package:sales/domain/usecases/app/change_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/app/change_language_usecase.dart';
import 'package:sales/domain/usecases/app/get_app_version_usecase.dart';
import 'package:sales/domain/usecases/app/get_current_brightness_usecase.dart';
import 'package:sales/domain/usecases/app/get_current_language_usecase.dart';
import 'package:sales/domain/usecases/app/get_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/app/get_supported_languages_usecase.dart';
import 'package:sales/domain/usecases/app/initialize_language_usecase.dart';
import 'package:sales/domain/usecases/app/on_language_changed_usecase.dart';
import 'package:sales/domain/usecases/app/print_image_bytes_as_pdf_usecase.dart';
import 'package:sales/domain/usecases/app/set_brightness_usecase.dart';
import 'package:sales/domain/usecases/auth/auto_login_usecase.dart';
import 'package:sales/domain/usecases/auth/get_cached_credentials_usecase.dart';
import 'package:sales/domain/usecases/auth/get_login_state_usecase.dart';
import 'package:sales/domain/usecases/auth/login_usecase.dart';
import 'package:sales/domain/usecases/auth/logout_usecase.dart';
import 'package:sales/domain/usecases/backup_restore/backup_database_usecase.dart';
import 'package:sales/domain/usecases/backup_restore/restore_database_usecase.dart';
import 'package:sales/domain/usecases/categories/add_all_categories_usecase.dart';
import 'package:sales/domain/usecases/categories/add_category_usecase.dart';
import 'package:sales/domain/usecases/categories/get_all_categories.dart';
import 'package:sales/domain/usecases/categories/get_next_category_id_usecase.dart';
import 'package:sales/domain/usecases/categories/remove_category_usecase.dart';
import 'package:sales/domain/usecases/categories/update_category_usecase.dart';
import 'package:sales/domain/usecases/data_services/download_template_usecase.dart';
import 'package:sales/domain/usecases/data_services/import_data_usecase.dart';
import 'package:sales/domain/usecases/data_services/load_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/data_services/load_server_connection_usecase.dart';
import 'package:sales/domain/usecases/data_services/remove_all_database_usecase.dart';
import 'package:sales/domain/usecases/data_services/replace_database_usecase.dart';
import 'package:sales/domain/usecases/data_services/save_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/discount/add_all_discounts_usecase.dart';
import 'package:sales/domain/usecases/discount/add_discount_usecase.dart';
import 'package:sales/domain/usecases/discount/get_all_available_discounts_usecase.dart';
import 'package:sales/domain/usecases/discount/get_all_discounts_usecase.dart';
import 'package:sales/domain/usecases/discount/get_discount_by_code_usecase.dart';
import 'package:sales/domain/usecases/discount/get_discounts_by_order_id_usecase.dart';
import 'package:sales/domain/usecases/discount/remove_discount_usecase.dart';
import 'package:sales/domain/usecases/discount/update_discount_usecase.dart';
import 'package:sales/domain/usecases/last_view/get_last_view_usecase.dart';
import 'package:sales/domain/usecases/last_view/get_save_last_view_usecase.dart';
import 'package:sales/domain/usecases/last_view/set_last_view_usecase.dart';
import 'package:sales/domain/usecases/last_view/set_save_last_view_usecase.dart';
import 'package:sales/domain/usecases/license/active_license_usecase.dart';
import 'package:sales/domain/usecases/license/active_trial_license_usecase.dart';
import 'package:sales/domain/usecases/license/can_active_trial_license_usecase.dart';
import 'package:sales/domain/usecases/license/get_license_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/add_all_orders_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/add_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_all_orders_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_next_order_item_id_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_order_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_temporary_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/remove_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/remove_temporary_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/save_temporary_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/update_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/orders/get_next_order_id_usecase.dart';
import 'package:sales/domain/usecases/orders/get_orders_usecase.dart';
import 'package:sales/domain/usecases/products/add_all_products_usecase.dart';
import 'package:sales/domain/usecases/products/add_product_usecase.dart';
import 'package:sales/domain/usecases/products/get_all_products_usecase.dart';
import 'package:sales/domain/usecases/products/get_next_product_id_and_sku_usecase.dart';
import 'package:sales/domain/usecases/products/get_products_usecase.dart';
import 'package:sales/domain/usecases/products/get_temporary_product_usecase.dart';
import 'package:sales/domain/usecases/products/get_total_product_count_usecase.dart';
import 'package:sales/domain/usecases/products/remove_product_usecase.dart';
import 'package:sales/domain/usecases/products/remove_temporary_product_usecase.dart';
import 'package:sales/domain/usecases/products/save_temporary_product_usecase.dart';
import 'package:sales/domain/usecases/products/update_product_usecase.dart';
import 'package:sales/domain/usecases/reports/get_daily_order_count_usecase.dart';
import 'package:sales/domain/usecases/reports/get_daily_revenue_for_month_usecase.dart';
import 'package:sales/domain/usecases/reports/get_daily_revenues_usecase.dart';
import 'package:sales/domain/usecases/reports/get_five_highest_sales_products_usecase.dart';
import 'package:sales/domain/usecases/reports/get_five_low_stock_products_usecase.dart';
import 'package:sales/domain/usecases/reports/get_profit_usecase.dart';
import 'package:sales/domain/usecases/reports/get_revenue_usecase.dart';
import 'package:sales/domain/usecases/reports/get_sold_products_with_quantity_usecase.dart';
import 'package:sales/domain/usecases/reports/get_three_recent_orders_usecase.dart';
import 'package:sales/infrastructure/data_import/excel_data_importer_repository_impl.dart';
import 'package:sales/infrastructure/respositories/app_version_repository_impl.dart';
import 'package:sales/infrastructure/respositories/backup_restore_repository_impl.dart';
import 'package:sales/infrastructure/respositories/brightness_repository_impl.dart';
import 'package:sales/infrastructure/respositories/category_repository_impl.dart';
import 'package:sales/infrastructure/respositories/discount_repository_impl.dart';
import 'package:sales/infrastructure/respositories/language_repository_impl.dart';
import 'package:sales/infrastructure/respositories/last_view_repository_impl.dart';
import 'package:sales/infrastructure/respositories/license_repository_impl.dart';
import 'package:sales/infrastructure/respositories/local_auth_repository_impl.dart';
import 'package:sales/infrastructure/respositories/order_item_repository_impl.dart';
import 'package:sales/infrastructure/respositories/order_repository_impl.dart';
import 'package:sales/infrastructure/respositories/order_with_items_repository_impl.dart';
import 'package:sales/infrastructure/respositories/page_configurations_repository_impl.dart';
import 'package:sales/infrastructure/respositories/postgres_configurations_repository_impl.dart';
import 'package:sales/infrastructure/respositories/print_repository_impl.dart';
import 'package:sales/infrastructure/respositories/product_repository_impl.dart';
import 'package:sales/infrastructure/respositories/report_repository_impl.dart';
import 'package:sales/infrastructure/respositories/temporary_data_repository_impl.dart';
import 'package:sales/infrastructure/services/database_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerSingleton<LanguageHelper>(LanguageHelper.instance)
    ..registerLazySingleton<FilePicker>(() => FilePicker.platform);

  _registerRepositories();
  _registerLocalPostgresDatabase();
  _registerUseCases();
  _registerServices();

  await getIt<InitializeLanguageUseCase>()(NoParams());
  _updateFeaturesTourGlobalConfigurations();
  getIt<OnLanguageChangedUseCase>()(NoParams()).listen((value) {
    _updateFeaturesTourGlobalConfigurations();
  });
}

void _updateFeaturesTourGlobalConfigurations() {
  FeaturesTour.setGlobalConfig(
    childConfig: ChildConfig(
      isAnimateChild: false,
      zoomScale: 1,
    ),
    predialogConfig: PredialogConfig(
      title: 'Giới Thiệu'.tr,
      content: 'Trang này có một số chức năng mới mà bạn có thể muốn khám phá.\n\n'
              'Bạn có muốn khám phá không?'
          .tr,
      applyToAllPagesText: 'Áp dụng với tất cả các trang'.tr,
      acceptButtonText: Text('Chấp nhận'.tr),
      laterButtonText: Text('Để sau'.tr),
      dismissButtonText: Text(
        'Bỏ qua'.tr,
        style: const TextStyle(color: Colors.grey),
      ),
    ),
    skipConfig: SkipConfig(text: 'Bỏ Qua'.tr),
    nextConfig: NextConfig(text: 'Tiếp'.tr),
    doneConfig: DoneConfig(text: 'Hoàn Thành'.tr),
  );
}

void _registerUseCases() {
  _registerAuthUseCases();
  _registerAppUseCases();
  _registerCategoryUseCases();
  _registerDatabaseUseCases();
  _registerOrderUseCases();
  _registerProductUseCases();
  _registerReportUseCases();
  _registerBackupRestoreUseCases();
  _registerPrintUseCases();
  _registerLicenseUseCases();
  _registerLastViewUseCases();
  _registerDiscountUseCases();
}

void _registerRepositories() {
  getIt
    ..registerLazySingleton<AuthRepository>(() => LocalAuthRepositoryImpl(getIt()))
    ..registerLazySingleton<ServerConfigurationsRepository>(() => PostgresConfigurationsRepositoryImpl(getIt()))
    ..registerLazySingleton<AppVersionRepository>(AppVersionRepositoryImpl.new)
    ..registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()))
    ..registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(getIt()))
    ..registerLazySingleton<OrderItemRepository>(() => OrderItemRepositoryImpl(getIt()))
    ..registerLazySingleton<OrderWithItemsRepository>(() => OrderWithItemsRepositoryImpl(getIt()))
    ..registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(getIt()))
    ..registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(getIt()))
    ..registerLazySingleton<DataImporterRepository>(ExcelDataImporterImpl.new)
    ..registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl(getIt()))
    ..registerLazySingleton<PageConfigurationsRepository>(() => PageConfigurationsRepositoryImpl(getIt()))
    ..registerLazySingleton<BrightnessRepository>(() => BrightnessRepositoryImpl(getIt()))
    ..registerLazySingleton<BackupRestoreRepository>(() => BackupRestoreRepositoryImpl(getIt()))
    ..registerLazySingleton<TemporaryDataRepository>(() => TemporaryDataRepositoryImpl(getIt()))
    ..registerLazySingleton<PrintRepository>(PrintRepositoryImpl.new)
    ..registerLazySingleton<LicenseRepository>(() => LicenseRepositoryImpl(getIt()))
    ..registerLazySingleton<LastViewRepository>(() => LastViewRepositoryImpl(getIt()))
    ..registerLazySingleton<DiscountRepository>(() => DiscountRepositoryImpl(getIt()));
}

void _registerLocalPostgresDatabase() {
  getIt
    ..registerLazySingleton<CoreDatabaseRepository>(() => PostgresCoreImpl(getIt()))
    ..registerLazySingleton<CategoryDatabaseRepository>(() => PostgresCategoryImpl(getIt()))
    ..registerLazySingleton<DataSyncDatabaseRepository>(
      () => PostgresDataSyncImpl(getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton<ProductDatabaseRepository>(() => PostgresProductImpl(getIt()))
    ..registerLazySingleton<OrderDatabaseRepository>(() => PostgresOrderImpl(getIt()))
    ..registerLazySingleton<OrderItemDatabaseRepository>(() => PostgresOrderItemImpl(getIt()))
    ..registerLazySingleton<OrderWithItemsDatabaseRepository>(
      () => PostgresOrderWithItemsImpl(getIt(), getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton<ReportDatabaseRepository>(() => PostgresReportImpl(getIt(), getIt(), getIt()))
    ..registerLazySingleton<DiscountDatabaseRepository>(() => PostgresDiscountImpl(getIt()));
}

void _registerAppUseCases() {
  getIt
    ..registerLazySingleton<GetAppVersionUseCase>(() => GetAppVersionUseCase(getIt()))
    ..registerLazySingleton<InitializeLanguageUseCase>(() => InitializeLanguageUseCase(getIt()))
    ..registerLazySingleton<OnLanguageChangedUseCase>(() => OnLanguageChangedUseCase(getIt()))
    ..registerLazySingleton<GetCurrentLanguageUseCase>(() => GetCurrentLanguageUseCase(getIt()))
    ..registerLazySingleton<GetSupportedLanguagesUseCase>(() => GetSupportedLanguagesUseCase(getIt()))
    ..registerLazySingleton<ChangeLanguageUseCase>(() => ChangeLanguageUseCase(getIt()))
    ..registerLazySingleton<ChangeItemPerPageUseCase>(() => ChangeItemPerPageUseCase(getIt()))
    ..registerLazySingleton<GetItemPerPageUseCase>(() => GetItemPerPageUseCase(getIt()))
    ..registerLazySingleton<GetCurrentBrightnessUseCase>(() => GetCurrentBrightnessUseCase(getIt()))
    ..registerLazySingleton<SetBrightnessUseCase>(() => SetBrightnessUseCase(getIt()));
}

void _registerAuthUseCases() {
  getIt
    ..registerLazySingleton<AutoLoginUseCase>(() => AutoLoginUseCase(getIt()))
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()))
    ..registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()))
    ..registerLazySingleton<GetLoginStateUseCase>(() => GetLoginStateUseCase(getIt()))
    ..registerLazySingleton<GetCachedCredentialsUseCase>(() => GetCachedCredentialsUseCase(getIt()));
}

void _registerProductUseCases() {
  getIt
    ..registerLazySingleton<GetTotalProductCountUseCase>(() => GetTotalProductCountUseCase(getIt()))
    ..registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(getIt()))
    ..registerLazySingleton<AddProductUseCase>(() => AddProductUseCase(getIt()))
    ..registerLazySingleton<UpdateProductUseCase>(() => UpdateProductUseCase(getIt()))
    ..registerLazySingleton<RemoveProductUseCase>(() => RemoveProductUseCase(getIt()))
    ..registerLazySingleton<GetNextProductIdAndSkuUseCase>(() => GetNextProductIdAndSkuUseCase(getIt()))
    ..registerLazySingleton<GetAllProductsUseCase>(() => GetAllProductsUseCase(getIt()))
    ..registerLazySingleton<AddAllProductsUseCase>(() => AddAllProductsUseCase(getIt()))
    ..registerLazySingleton<SaveTemporaryProductUseCase>(() => SaveTemporaryProductUseCase(getIt()))
    ..registerLazySingleton<GetTemporaryProductUseCase>(() => GetTemporaryProductUseCase(getIt()))
    ..registerLazySingleton<RemoveTemporaryProductUseCase>(() => RemoveTemporaryProductUseCase(getIt()));
}

void _registerOrderUseCases() {
  getIt
    ..registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(getIt()))
    ..registerLazySingleton<GetOrderItemsUseCase>(() => GetOrderItemsUseCase(getIt()))
    ..registerLazySingleton<GetNextOrderIdUseCase>(() => GetNextOrderIdUseCase(getIt()))
    ..registerLazySingleton<GetNextOrderItemIdUseCase>(() => GetNextOrderItemIdUseCase(getIt()))
    ..registerLazySingleton<AddOrderWithItemsUseCase>(() => AddOrderWithItemsUseCase(getIt()))
    ..registerLazySingleton<UpdateOrderWithItemsUseCase>(() => UpdateOrderWithItemsUseCase(getIt()))
    ..registerLazySingleton<RemoveOrderWithItemsUseCase>(() => RemoveOrderWithItemsUseCase(getIt()))
    ..registerLazySingleton<GetAllOrdersWithItemsUseCase>(() => GetAllOrdersWithItemsUseCase(getIt()))
    ..registerLazySingleton<AddAllOrdersWithItemsUseCase>(() => AddAllOrdersWithItemsUseCase(getIt()))
    ..registerLazySingleton<SaveTemporaryOrderWithItemsUseCase>(() => SaveTemporaryOrderWithItemsUseCase(getIt()))
    ..registerLazySingleton<GetTemporaryOrderWithItemsUseCase>(() => GetTemporaryOrderWithItemsUseCase(getIt()))
    ..registerLazySingleton<RemoveTemporaryOrderWithItemsUseCase>(() => RemoveTemporaryOrderWithItemsUseCase(getIt()));
}

void _registerCategoryUseCases() {
  getIt
    ..registerLazySingleton<AddCategoryUseCase>(() => AddCategoryUseCase(getIt()))
    ..registerLazySingleton<RemoveCategoryUseCase>(() => RemoveCategoryUseCase(getIt()))
    ..registerLazySingleton<UpdateCategoryUseCase>(() => UpdateCategoryUseCase(getIt()))
    ..registerLazySingleton<GetAllCategoriesUsecCase>(() => GetAllCategoriesUsecCase(getIt()))
    ..registerLazySingleton<GetNextCategoryIdUseCase>(() => GetNextCategoryIdUseCase(getIt()))
    ..registerLazySingleton<AddAllCategoriesUseCase>(() => AddAllCategoriesUseCase(getIt()));
}

void _registerReportUseCases() {
  getIt
    ..registerLazySingleton<GetDailyOrderCountUseCase>(() => GetDailyOrderCountUseCase(getIt()))
    ..registerLazySingleton<GetDailyRevenueUseCase>(() => GetDailyRevenueUseCase(getIt()))
    ..registerLazySingleton<GetFiveHighestSalesProductsUseCase>(() => GetFiveHighestSalesProductsUseCase(getIt()))
    ..registerLazySingleton<GetFiveLowStockProductsUseCase>(() => GetFiveLowStockProductsUseCase(getIt()))
    ..registerLazySingleton<GetDailyRevenueForMonth>(() => GetDailyRevenueForMonth(getIt()))
    ..registerLazySingleton<GetThreeRecentOrdersUseCase>(() => GetThreeRecentOrdersUseCase(getIt()))
    ..registerLazySingleton<GetSoldProductsWithQuantityUsecase>(() => GetSoldProductsWithQuantityUsecase(getIt()))
    ..registerLazySingleton<GetRevenueUseCase>(() => GetRevenueUseCase(getIt()))
    ..registerLazySingleton<GetProfitUseCase>(() => GetProfitUseCase(getIt()));
}

void _registerDatabaseUseCases() {
  getIt
    ..registerLazySingleton(() => RemoveAllDatabaseUseCase(getIt()))
    ..registerLazySingleton<LoadServerConfigurationUseCase>(() => LoadServerConfigurationUseCase(getIt()))
    ..registerLazySingleton<SaveServerConfigurationUseCase>(() => SaveServerConfigurationUseCase(getIt()))
    ..registerLazySingleton<LoadServerConnectionUsecase>(() => LoadServerConnectionUsecase(getIt()))
    ..registerLazySingleton<ReplaceDatabaseUsecase>(() => ReplaceDatabaseUsecase(getIt()))
    ..registerLazySingleton<ImportDataUseCase>(() => ImportDataUseCase(getIt()))
    ..registerLazySingleton<DownloadTemplateUseCase>(() => DownloadTemplateUseCase(getIt()));
}

void _registerBackupRestoreUseCases() {
  getIt
    ..registerLazySingleton<BackupDatabaseUseCase>(() => BackupDatabaseUseCase(getIt()))
    ..registerLazySingleton<RestoreDatabaseUseCase>(() => RestoreDatabaseUseCase(getIt()));
}

void _registerPrintUseCases() {
  getIt.registerLazySingleton<PrintImageBytesAsPdfUseCase>(() => PrintImageBytesAsPdfUseCase(getIt()));
}

void _registerLicenseUseCases() {
  getIt
    ..registerLazySingleton<ActiveLicenseUseCase>(() => ActiveLicenseUseCase(getIt()))
    ..registerLazySingleton<ActiveTrialLicenseUseCase>(() => ActiveTrialLicenseUseCase(getIt()))
    ..registerLazySingleton<CanActiveTrialLicenseUseCase>(() => CanActiveTrialLicenseUseCase(getIt()))
    ..registerLazySingleton<GetLicenseUseCase>(() => GetLicenseUseCase(getIt()));
}

void _registerLastViewUseCases() {
  getIt
    ..registerLazySingleton<GetLastViewUseCase>(() => GetLastViewUseCase(getIt()))
    ..registerLazySingleton<GetSaveLastViewUsecase>(() => GetSaveLastViewUsecase(getIt()))
    ..registerLazySingleton<SetLastViewUseCase>(() => SetLastViewUseCase(getIt()))
    ..registerLazySingleton<SetSaveLastViewUseCase>(() => SetSaveLastViewUseCase(getIt()));
}

void _registerDiscountUseCases() {
  getIt
    ..registerLazySingleton(() => AddDiscountUseCase(getIt()))
    ..registerLazySingleton(() => UpdateDiscountUseCase(getIt()))
    ..registerLazySingleton(() => GetDiscountByCodeUseCase(getIt()))
    ..registerLazySingleton(() => GetDiscountsByOrderIdUseCase(getIt()))
    ..registerLazySingleton(() => GetAllAvailableDiscountsUseCase(getIt()))
    ..registerLazySingleton(() => GetAllDiscountsUseCase(getIt()))
    ..registerLazySingleton(() => AddAllDiscountsUseCase(getIt()))
    ..registerLazySingleton(() => RemoveDiscountUseCase(getIt()));
}

void _registerServices() {
  getIt.registerLazySingleton<DatabaseService>(
    () => DatabaseServiceImpl(
      coreDatabase: getIt(),
      dataSyncDatabase: getIt(),
      filePicker: getIt(),
    ),
  );
}
