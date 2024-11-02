import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/di.dart';
import 'package:sales/presentation/riverpod/notifiers/app_settings_provider.dart';
import 'package:sales/presentation/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsState = ref.watch(appSettingsProvider);
    return MaterialApp(
      localizationsDelegates: LanguageHelper.instance.delegates,
      locale: appSettingsState.currentlanguage.locale,
      supportedLocales: appSettingsState.supportedLanguages.map((e) => e.locale),
      themeMode: appSettingsState.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: Colors.blue, brightness: Brightness.dark),
      home: const LoginView(),
    );
  }
}
