import 'package:flutter/material.dart';
import 'package:sales/app/app.dart';
import 'package:sales/di.dart';

void main() async {
  await setup();
  runApp(const App());
}
