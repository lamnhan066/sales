import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/app/app.dart';
import 'package:sales/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await setupDependencies();
  runApp(const ProviderScope(child: App()));
}
