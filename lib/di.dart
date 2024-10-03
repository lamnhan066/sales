import 'package:get_it/get_it.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/controllers/dashboard_controller.dart';
import 'package:sales/controllers/home_controller.dart';
import 'package:sales/controllers/login_controller.dart';
import 'package:sales/controllers/order_controller.dart';
import 'package:sales/controllers/product_controller.dart';
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
  getIt.registerSingleton<LoginController>(LoginController());
  getIt.registerSingleton<ProductController>(ProductController());
  getIt.registerSingleton<DashboardController>(DashboardController());
  getIt.registerSingleton<OrderController>(OrderController());
}
