import 'package:flutter/material.dart';
import 'package:sales/app/app.dart';
import 'package:sales/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const App());
}
