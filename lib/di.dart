import 'package:features_tour/features_tour.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/data/database/category_database.dart';
import 'package:sales/data/database/core_database.dart';
import 'package:sales/data/database/data_sync_database.dart';
import 'package:sales/data/database/order_database.dart';
import 'package:sales/data/database/order_item_database.dart';
import 'package:sales/data/database/order_with_items_database.dart';
import 'package:sales/data/database/product_database.dart';
import 'package:sales/data/database/report_database.dart';
import 'package:sales/data/source/local_postgres/local_postgres_storage.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';
import 'package:sales/domain/repositories/brightness_repository.dart';
import 'package:sales/domain/repositories/category_repository.dart';
import 'package:sales/domain/repositories/data_importer_repository.dart';
import 'package:sales/domain/repositories/language_repository.dart';
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
import 'package:sales/domain/usecases/data_services/import_data_usecase.dart';
import 'package:sales/domain/usecases/data_services/load_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/data_services/load_server_connection_usecase.dart';
import 'package:sales/domain/usecases/data_services/replace_database_usecase.dart';
import 'package:sales/domain/usecases/data_services/save_server_configuration_usecase.dart';
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
import 'package:sales/infrastructure/respositories/language_repository_impl.dart';
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
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<LanguageHelper>(LanguageHelper.instance);
  getIt.registerLazySingleton<FilePicker>(() => FilePicker.platform);

  _registerRepositories();
  _registerDatabase();
  _registerUseCases();
  _registerServices();

  await getIt<InitializeLanguageUseCase>()(NoParams());
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
}

void _registerRepositories() {
  getIt.registerLazySingleton<AuthRepository>(() => LocalAuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ServerConfigurationsRepository>(() => PostgresConfigurationsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<AppVersionRepository>(() => AppVersionRepositoryImpl());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(getIt()));
  getIt.registerLazySingleton<OrderItemRepository>(() => OrderItemRepositoryImpl(getIt()));
  getIt.registerLazySingleton<OrderWithItemsRepository>(() => OrderWithItemsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(getIt()));
  getIt.registerLazySingleton<DataImporterRepository>(() => ExcelDataImporterImpl());
  getIt.registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl(getIt()));
  getIt.registerLazySingleton<PageConfigurationsRepository>(() => PageConfigurationsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<BrightnessRepository>(() => BrightnessRepositoryImpl(getIt()));
  getIt.registerLazySingleton<BackupRestoreRepository>(() => BackupRestoreRepositoryImpl(getIt()));
  getIt.registerLazySingleton<TemporaryDataRepository>(() => TemporaryDataRepositoryImpl(getIt()));
  getIt.registerLazySingleton<PrintRepository>(() => PrintRepositoryImpl());
}

void _registerDatabase() {
  final postgresDatabase = LocalPostgresStorageImpl(getIt());

  getIt.registerLazySingleton<CoreDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<CategoryDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<DataSyncDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<ProductDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<OrderDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<OrderItemDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<OrderWithItemsDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<ReportDatabase>(() => postgresDatabase);
}

void _registerAppUseCases() {
  getIt.registerLazySingleton<GetAppVersionUseCase>(() => GetAppVersionUseCase(getIt()));
  getIt.registerLazySingleton<InitializeLanguageUseCase>(() => InitializeLanguageUseCase(getIt()));
  getIt.registerLazySingleton<GetCurrentLanguageUseCase>(() => GetCurrentLanguageUseCase(getIt()));
  getIt.registerLazySingleton<GetSupportedLanguagesUseCase>(() => GetSupportedLanguagesUseCase(getIt()));
  getIt.registerLazySingleton<ChangeLanguageUseCase>(() => ChangeLanguageUseCase(getIt()));
  getIt.registerLazySingleton<ChangeItemPerPageUseCase>(() => ChangeItemPerPageUseCase(getIt()));
  getIt.registerLazySingleton<GetItemPerPageUseCase>(() => GetItemPerPageUseCase(getIt()));
  getIt.registerLazySingleton<GetCurrentBrightnessUseCase>(() => GetCurrentBrightnessUseCase(getIt()));
  getIt.registerLazySingleton<SetBrightnessUseCase>(() => SetBrightnessUseCase(getIt()));
}

void _registerAuthUseCases() {
  getIt.registerLazySingleton<AutoLoginUseCase>(() => AutoLoginUseCase(getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton<GetLoginStateUseCase>(() => GetLoginStateUseCase(getIt()));
  getIt.registerLazySingleton<GetCachedCredentialsUseCase>(() => GetCachedCredentialsUseCase(getIt()));
}

void _registerProductUseCases() {
  getIt.registerLazySingleton<GetTotalProductCountUseCase>(() => GetTotalProductCountUseCase(getIt()));
  getIt.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton<AddProductUseCase>(() => AddProductUseCase(getIt()));
  getIt.registerLazySingleton<UpdateProductUseCase>(() => UpdateProductUseCase(getIt()));
  getIt.registerLazySingleton<RemoveProductUseCase>(() => RemoveProductUseCase(getIt()));
  getIt.registerLazySingleton<GetNextProductIdAndSkuUseCase>(() => GetNextProductIdAndSkuUseCase(getIt()));
  getIt.registerLazySingleton<GetAllProductsUseCase>(() => GetAllProductsUseCase(getIt()));
  getIt.registerLazySingleton<AddAllProductsUseCase>(() => AddAllProductsUseCase(getIt()));
  getIt.registerLazySingleton<SaveTemporaryProductUseCase>(() => SaveTemporaryProductUseCase(getIt()));
  getIt.registerLazySingleton<GetTemporaryProductUseCase>(() => GetTemporaryProductUseCase(getIt()));
  getIt.registerLazySingleton<RemoveTemporaryProductUseCase>(() => RemoveTemporaryProductUseCase(getIt()));
}

void _registerOrderUseCases() {
  getIt.registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(getIt()));
  getIt.registerLazySingleton<GetOrderItemsUseCase>(() => GetOrderItemsUseCase(getIt()));
  getIt.registerLazySingleton<GetNextOrderIdUseCase>(() => GetNextOrderIdUseCase(getIt()));
  getIt.registerLazySingleton<GetNextOrderItemIdUseCase>(() => GetNextOrderItemIdUseCase(getIt()));
  getIt.registerLazySingleton<AddOrderWithItemsUseCase>(() => AddOrderWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<UpdateOrderWithItemsUseCase>(() => UpdateOrderWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<RemoveOrderWithItemsUseCase>(() => RemoveOrderWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<GetAllOrdersWithItemsUseCase>(() => GetAllOrdersWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<AddAllOrdersWithItemsUseCase>(() => AddAllOrdersWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<SaveTemporaryOrderWithItemsUseCase>(() => SaveTemporaryOrderWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<GetTemporaryOrderWithItemsUseCase>(() => GetTemporaryOrderWithItemsUseCase(getIt()));
  getIt
      .registerLazySingleton<RemoveTemporaryOrderWithItemsUseCase>(() => RemoveTemporaryOrderWithItemsUseCase(getIt()));
}

void _registerCategoryUseCases() {
  getIt.registerLazySingleton<AddCategoryUseCase>(() => AddCategoryUseCase(getIt()));
  getIt.registerLazySingleton<RemoveCategoryUseCase>(() => RemoveCategoryUseCase(getIt()));
  getIt.registerLazySingleton<UpdateCategoryUseCase>(() => UpdateCategoryUseCase(getIt()));
  getIt.registerLazySingleton<GetAllCategoriesUsecCase>(() => GetAllCategoriesUsecCase(getIt()));
  getIt.registerLazySingleton<GetNextCategoryIdUseCase>(() => GetNextCategoryIdUseCase(getIt()));
  getIt.registerLazySingleton<AddAllCategoriesUseCase>(() => AddAllCategoriesUseCase(getIt()));
}

void _registerReportUseCases() {
  getIt.registerLazySingleton<GetDailyOrderCountUseCase>(() => GetDailyOrderCountUseCase(getIt()));
  getIt.registerLazySingleton<GetDailyRevenueUseCase>(() => GetDailyRevenueUseCase(getIt()));
  getIt.registerLazySingleton<GetFiveHighestSalesProductsUseCase>(() => GetFiveHighestSalesProductsUseCase(getIt()));
  getIt.registerLazySingleton<GetFiveLowStockProductsUseCase>(() => GetFiveLowStockProductsUseCase(getIt()));
  getIt.registerLazySingleton<GetDailyRevenueForMonth>(() => GetDailyRevenueForMonth(getIt()));
  getIt.registerLazySingleton<GetThreeRecentOrdersUseCase>(() => GetThreeRecentOrdersUseCase(getIt()));
  getIt.registerLazySingleton<GetSoldProductsWithQuantityUsecase>(() => GetSoldProductsWithQuantityUsecase(getIt()));
  getIt.registerLazySingleton<GetRevenueUseCase>(() => GetRevenueUseCase(getIt()));
  getIt.registerLazySingleton<GetProfitUseCase>(() => GetProfitUseCase(getIt()));
}

void _registerDatabaseUseCases() {
  getIt.registerLazySingleton<LoadServerConfigurationUseCase>(() => LoadServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<SaveServerConfigurationUseCase>(() => SaveServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<LoadServerConnectionUsecase>(() => LoadServerConnectionUsecase(getIt()));
  getIt.registerLazySingleton<ReplaceDatabaseUsecase>(() => ReplaceDatabaseUsecase(getIt()));
  getIt.registerLazySingleton<ImportDataUseCase>(() => ImportDataUseCase(getIt()));
}

void _registerBackupRestoreUseCases() {
  getIt.registerLazySingleton<BackupDatabaseUseCase>(() => BackupDatabaseUseCase(getIt()));
  getIt.registerLazySingleton<RestoreDatabaseUseCase>(() => RestoreDatabaseUseCase(getIt()));
}

void _registerPrintUseCases() {
  getIt.registerLazySingleton<PrintImageBytesAsPdfUseCase>(() => PrintImageBytesAsPdfUseCase(getIt()));
}

void _registerServices() {
  getIt.registerLazySingleton<DatabaseService>(
    () => DatabaseServiceImpl(coreDatabase: getIt(), dataSyncDatabase: getIt()),
  );
}
