import 'package:flutter/material.dart';
import 'package:sales/core/constants/app_configs.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key, this.leadings = const [], this.trailings = const []});

  final List<Widget> leadings;
  final List<Widget> trailings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: AppConfigs.toolbarHeight,
        child: Row(
          children: [
            ...leadings,
            const Spacer(),
            Row(
              children: [
                ...trailings,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
