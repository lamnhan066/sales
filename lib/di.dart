import 'package:get_it/get_it.dart';
import 'package:sales/controllers/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(preferences);
  getIt.registerSingleton(LoginController());
}
