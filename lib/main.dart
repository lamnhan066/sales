import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/di.dart';
import 'package:sales/presentation/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const ProviderScope(child: MaterialApp(home: LoginView())));
}
