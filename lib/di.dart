import 'package:get_it/get_it.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/application/usecases/auto_login_usecase.dart';
import 'package:sales/application/usecases/get_app_version_usecase.dart';
import 'package:sales/application/usecases/get_daily_order_count_usecase.dart';
import 'package:sales/application/usecases/get_daily_revenues_usecase.dart';
import 'package:sales/application/usecases/get_five_highest_sales_products_usecase.dart';
import 'package:sales/application/usecases/get_five_low_stock_products_usecase.dart';
import 'package:sales/application/usecases/get_monthly_revenues_usecase.dart';
import 'package:sales/application/usecases/get_three_recent_orders_usecase.dart';
import 'package:sales/application/usecases/get_total_product_count_usecase.dart';
import 'package:sales/application/usecases/load_server_configuration_usecase.dart';
import 'package:sales/application/usecases/login_usecase.dart';
import 'package:sales/application/usecases/save_server_configuration_usecase.dart';
import 'package:sales/controllers/home_controller.dart';
import 'package:sales/controllers/order_controller.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';
import 'package:sales/infrastucture/database/database.dart';
import 'package:sales/infrastucture/database/sample_memory_database_impl.dart';
import 'package:sales/infrastucture/respositories/app_version_repository_impl.dart';
import 'package:sales/infrastucture/respositories/local_auth_repository_impl.dart';
import 'package:sales/infrastucture/respositories/order_repository_impl.dart';
import 'package:sales/infrastucture/respositories/postgres_configurations_repository_impl.dart';
import 'package:sales/infrastucture/respositories/product_repository_impl.dart';
import 'package:sales/services/database/database.dart' as d;
import 'package:sales/services/database/sample_memory_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service locator.
final getIt = GetIt.instance;

/// Setup for the service locator.
Future<void> setup() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<AppController>(AppController());
  getIt.registerSingleton<HomeController>(HomeController());
  getIt.registerSingleton<d.Database>(SampleMemoryDatabase());
  getIt.registerSingleton<ProductController>(ProductController());
  getIt.registerSingleton<OrderController>(OrderController());
}

Future<void> setupDependencies() async {
  // Register Repositories
  getIt.registerLazySingleton<AuthRepository>(() => LocalAuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ServerConfigurationsRepository>(() => PostgresConfigurationsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<AppVersionRepository>(() => AppVersionRepositoryImpl());
  getIt.registerLazySingleton<Database>(() => SampleMemoryDatabaseImpl());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(getIt()));

  // Register Use Cases
  getIt.registerLazySingleton<AutoLoginUseCase>(() => AutoLoginUseCase(getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<GetAppVersionUseCase>(() => GetAppVersionUseCase(getIt()));
  getIt.registerLazySingleton<LoadServerConfigurationUseCase>(() => LoadServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<SaveServerConfigurationUseCase>(() => SaveServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<GetDailyOrderCountUseCase>(() => GetDailyOrderCountUseCase(getIt()));
  getIt.registerLazySingleton<GetDailyRevenueUseCase>(() => GetDailyRevenueUseCase(getIt()));
  getIt.registerLazySingleton<GetFiveHighestSalesProductsUseCase>(() => GetFiveHighestSalesProductsUseCase(getIt()));
  getIt.registerLazySingleton<GetFiveLowStockProductsUseCase>(() => GetFiveLowStockProductsUseCase(getIt()));
  getIt.registerLazySingleton<GetMonthlyRevenuesUseCase>(() => GetMonthlyRevenuesUseCase(getIt()));
  getIt.registerLazySingleton<GetThreeRecentOrdersUseCase>(() => GetThreeRecentOrdersUseCase(getIt()));
  getIt.registerLazySingleton<GetTotalProductCountUseCase>(() => GetTotalProductCountUseCase(getIt()));

  await getIt<Database>().initial();
}
