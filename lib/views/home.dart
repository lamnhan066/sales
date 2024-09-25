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
  bool loading = true;

  @override
  void initState() {
    loadSetup().then((_) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : appController.getLastView();
  }
}
