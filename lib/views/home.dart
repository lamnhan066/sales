import 'package:flutter/material.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/di.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appController = getIt<AppController>();

  @override
  Widget build(BuildContext context) {
    return appController.getLastView();
  }
}
