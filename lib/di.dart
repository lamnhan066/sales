import 'package:get_it/get_it.dart';
import 'package:sales/controllers/login_controller.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/services/database/database.dart';
import 'package:sales/services/database/test_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<LoginController>(LoginController());
  getIt.registerSingleton<Database>(TestDatabase());
  getIt.registerSingleton<ProductController>(ProductController());
}
