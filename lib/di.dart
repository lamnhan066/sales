import 'package:get_it/get_it.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/application/usecases/auto_login_usecase.dart';
import 'package:sales/application/usecases/get_app_version_usecase.dart';
import 'package:sales/application/usecases/load_server_configuration_usecase.dart';
import 'package:sales/application/usecases/login_usecase.dart';
import 'package:sales/application/usecases/save_server_configuration_usecase.dart';
import 'package:sales/controllers/dashboard_controller.dart';
import 'package:sales/controllers/home_controller.dart';
import 'package:sales/controllers/order_controller.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';
import 'package:sales/infrastucture/respositories/app_version_repository_impl.dart';
import 'package:sales/infrastucture/respositories/local_auth_repository_impl.dart';
import 'package:sales/infrastucture/respositories/postgres_configurations_repository_impl.dart';
import 'package:sales/services/database/database.dart';
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
  getIt.registerSingleton<Database>(SampleMemoryDatabase());
  getIt.registerSingleton<ProductController>(ProductController());
  getIt.registerSingleton<DashboardController>(DashboardController());
  getIt.registerSingleton<OrderController>(OrderController());
}

Future<void> setupDependencies() async {
  // Register Repositories
  getIt.registerLazySingleton<AuthRepository>(() => LocalAuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ServerConfigurationsRepository>(() => PostgresConfigurationsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<AppVersionRepository>(() => AppVersionRepositoryImpl());

  // Register Use Cases
  getIt.registerLazySingleton<AutoLoginUseCase>(() => AutoLoginUseCase(getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<GetAppVersionUseCase>(() => GetAppVersionUseCase(getIt()));
  getIt.registerLazySingleton<LoadServerConfigurationUseCase>(() => LoadServerConfigurationUseCase(getIt()));
  getIt.registerLazySingleton<SaveServerConfigurationUseCase>(() => SaveServerConfigurationUseCase(getIt()));
}
