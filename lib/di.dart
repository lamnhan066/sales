import 'package:get_it/get_it.dart';
import 'package:sales/data/database/category_database.dart';
import 'package:sales/data/database/core_database.dart';
import 'package:sales/data/database/data_sync_database.dart';
import 'package:sales/data/database/order_database.dart';
import 'package:sales/data/database/order_item_database.dart';
import 'package:sales/data/database/order_with_items_database.dart';
import 'package:sales/data/database/product_database.dart';
import 'package:sales/data/local/postgres_database_impl.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/domain/repositories/category_repository.dart';
import 'package:sales/domain/repositories/data_importer_repository.dart';
import 'package:sales/domain/repositories/order_item_repository.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';
import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';
import 'package:sales/domain/services/database_service.dart';
import 'package:sales/domain/usecases/add_category_usecase.dart';
import 'package:sales/domain/usecases/add_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/add_product_usecase.dart';
import 'package:sales/domain/usecases/auto_login_usecase.dart';
import 'package:sales/domain/usecases/get_all_categories.dart';
import 'package:sales/domain/usecases/get_all_products_usecase.dart';
import 'package:sales/domain/usecases/get_app_version_usecase.dart';
import 'package:sales/domain/usecases/get_cached_credentials_usecase.dart';
import 'package:sales/domain/usecases/get_daily_order_count_usecase.dart';
import 'package:sales/domain/usecases/get_daily_revenues_usecase.dart';
import 'package:sales/domain/usecases/get_five_highest_sales_products_usecase.dart';
import 'package:sales/domain/usecases/get_five_low_stock_products_usecase.dart';
import 'package:sales/domain/usecases/get_login_state_usecase.dart';
import 'package:sales/domain/usecases/get_monthly_revenues_usecase.dart';
import 'package:sales/domain/usecases/get_next_category_id_usecase.dart';
import 'package:sales/domain/usecases/get_next_order_id_usecase.dart';
import 'package:sales/domain/usecases/get_next_order_item_id_usecase.dart';
import 'package:sales/domain/usecases/get_next_product_id_and_sku_usecase.dart';
import 'package:sales/domain/usecases/get_order_items_usecase.dart';
import 'package:sales/domain/usecases/get_orders_usecase.dart';
import 'package:sales/domain/usecases/get_products_usecase.dart';
import 'package:sales/domain/usecases/get_three_recent_orders_usecase.dart';
import 'package:sales/domain/usecases/get_total_product_count_usecase.dart';
import 'package:sales/domain/usecases/import_data_usecase.dart';
import 'package:sales/domain/usecases/load_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/load_server_connection_usecase.dart';
import 'package:sales/domain/usecases/login_usecase.dart';
import 'package:sales/domain/usecases/logout_usecase.dart';
import 'package:sales/domain/usecases/remove_category_usecase.dart';
import 'package:sales/domain/usecases/remove_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/remove_product_usecase.dart';
import 'package:sales/domain/usecases/replace_database_usecase.dart';
import 'package:sales/domain/usecases/save_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/update_category_usecase.dart';
import 'package:sales/domain/usecases/update_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/update_product_usecase.dart';
import 'package:sales/infrastructure/data_import/excel_data_importer_repository_impl.dart';
import 'package:sales/infrastructure/respositories/app_version_repository_impl.dart';
import 'package:sales/infrastructure/respositories/category_repository_impl.dart';
import 'package:sales/infrastructure/respositories/local_auth_repository_impl.dart';
import 'package:sales/infrastructure/respositories/order_item_repository_impl.dart';
import 'package:sales/infrastructure/respositories/order_repository_impl.dart';
import 'package:sales/infrastructure/respositories/order_with_items_repository_impl.dart';
import 'package:sales/infrastructure/respositories/postgres_configurations_repository_impl.dart';
import 'package:sales/infrastructure/respositories/product_repository_impl.dart';
import 'package:sales/infrastructure/services/database_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);

  _registerRepositories();
  _registerDatabase();
  _registerUseCases();
  _registerServices();
}

void _registerUseCases() {
  _registerAuthUseCases();
  _registerCategoryUseCases();
  _registerDashboardUseCases();
  _registerDatabaseUseCases();
  _registerOrderUseCases();
  _registerProductUseCases();
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
  getIt.registerLazySingleton<DataImporterRepository>(() => ExcelDataImporterImpl());
}

void _registerDatabase() {
  final postgresDatabase = PostgresDatabaseImpl(getIt());

  getIt.registerLazySingleton<CoreDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<CategoryDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<DataSyncDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<ProductDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<OrderDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<OrderItemDatabase>(() => postgresDatabase);
  getIt.registerLazySingleton<OrderWithItemsDatabase>(() => postgresDatabase);
}

void _registerAuthUseCases() {
  getIt.registerLazySingleton<AutoLoginUseCase>(() => AutoLoginUseCase(getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton<GetLoginStateUseCase>(() => GetLoginStateUseCase(getIt()));
  getIt.registerLazySingleton<GetCachedCredentialsUseCase>(() => GetCachedCredentialsUseCase(getIt()));
  getIt.registerLazySingleton<GetAppVersionUseCase>(() => GetAppVersionUseCase(getIt()));
}

void _registerProductUseCases() {
  getIt.registerLazySingleton<GetTotalProductCountUseCase>(() => GetTotalProductCountUseCase(getIt()));
  getIt.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton<AddProductUseCase>(() => AddProductUseCase(getIt()));
  getIt.registerLazySingleton<UpdateProductUseCase>(() => UpdateProductUseCase(getIt()));
  getIt.registerLazySingleton<RemoveProductUseCase>(() => RemoveProductUseCase(getIt()));
  getIt.registerLazySingleton<GetNextProductIdAndSkuUseCase>(() => GetNextProductIdAndSkuUseCase(getIt()));
  getIt.registerLazySingleton<GetAllProductsUseCase>(() => GetAllProductsUseCase(getIt()));
}

void _registerOrderUseCases() {
  getIt.registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(getIt()));
  getIt.registerLazySingleton<GetOrderItemsUseCase>(() => GetOrderItemsUseCase(getIt()));
  getIt.registerLazySingleton<GetNextOrderIdUseCase>(() => GetNextOrderIdUseCase(getIt()));
  getIt.registerLazySingleton<GetNextOrderItemIdUseCase>(() => GetNextOrderItemIdUseCase(getIt()));
  getIt.registerLazySingleton<AddOrderWithItemsUseCase>(() => AddOrderWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<UpdateOrderWithItemsUseCase>(() => UpdateOrderWithItemsUseCase(getIt()));
  getIt.registerLazySingleton<RemoveOrderWithItemsUseCase>(() => RemoveOrderWithItemsUseCase(getIt()));
}

void _registerCategoryUseCases() {
  getIt.registerLazySingleton<AddCategoryUseCase>(() => AddCategoryUseCase(getIt()));
  getIt.registerLazySingleton<RemoveCategoryUseCase>(() => RemoveCategoryUseCase(getIt()));
  getIt.registerLazySingleton<UpdateCategoryUseCase>(() => UpdateCategoryUseCase(getIt()));
  getIt.registerLazySingleton<GetAllCategoriesUsecCase>(() => GetAllCategoriesUsecCase(getIt()));
  getIt.registerLazySingleton<GetNextCategoryIdUseCase>(() => GetNextCategoryIdUseCase(getIt()));
}

void _registerDatabaseUseCases() {
  getIt.registerLazySingleton<LoadServerConfigurationUseCase>(() => LoadServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<SaveServerConfigurationUseCase>(() => SaveServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<LoadServerConnectionUsecase>(() => LoadServerConnectionUsecase(getIt()));
  getIt.registerLazySingleton<ReplaceDatabaseUsecase>(() => ReplaceDatabaseUsecase(getIt()));
  getIt.registerLazySingleton<ImportDataUseCase>(() => ImportDataUseCase(getIt()));
}

void _registerDashboardUseCases() {
  getIt.registerLazySingleton<GetDailyOrderCountUseCase>(() => GetDailyOrderCountUseCase(getIt()));
  getIt.registerLazySingleton<GetDailyRevenueUseCase>(() => GetDailyRevenueUseCase(getIt()));
  getIt.registerLazySingleton<GetFiveHighestSalesProductsUseCase>(() => GetFiveHighestSalesProductsUseCase(getIt()));
  getIt.registerLazySingleton<GetFiveLowStockProductsUseCase>(() => GetFiveLowStockProductsUseCase(getIt()));
  getIt.registerLazySingleton<GetMonthlyRevenuesUseCase>(() => GetMonthlyRevenuesUseCase(getIt()));
  getIt.registerLazySingleton<GetThreeRecentOrdersUseCase>(() => GetThreeRecentOrdersUseCase(getIt()));
}

void _registerServices() {
  getIt.registerLazySingleton<DatabaseService>(
    () => DatabaseServiceImpl(coreDatabase: getIt(), dataSyncDatabase: getIt()),
  );
}
