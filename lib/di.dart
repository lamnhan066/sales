import 'package:get_it/get_it.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/controllers/dashboard_controller.dart';
import 'package:sales/controllers/login_controller.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/services/database/database.dart';
import 'package:sales/services/database/sample_memory_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<AppController>(AppController());
  getIt.registerSingleton<Database>(SampleMemoryDatabase());
  getIt.registerSingleton<LoginController>(LoginController());
  getIt.registerSingleton<ProductController>(ProductController());
  getIt.registerSingleton<DashboardController>(DashboardController());
}

Future<void> loadSetup() async {
  await getIt<AppController>().initial();
  await getIt<Database>().initial();
}
