import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/domain/entities/ranges.dart';

class OrderFilterDialog extends StatefulWidget {
  const OrderFilterDialog({
    super.key,
    required this.initialDateRange,
    required this.onDateRangeChanged,
  });

  final Ranges<DateTime?>? initialDateRange;
  final void Function(Ranges<DateTime?>? value) onDateRangeChanged;

  @override
  State<OrderFilterDialog> createState() => _OrderFilterDialogState();
}

class _OrderFilterDialogState extends State<OrderFilterDialog> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  Ranges<DateTime?>? values;

  @override
  void initState() {
    values = widget.initialDateRange;
    startController.text = values?.start?.toddMMyyyy() ?? '';
    endController.text = values?.end?.toddMMyyyy() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Text(
              'Lọc theo khoảng thời gian'.tr,
              style: const TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: BoxWInput(
                    controller: startController,
                    title: 'Từ'.tr,
                    readOnly: true,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final value = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );

                    startController.text = value?.toddMMyyyy() ?? '';
                    values = Ranges(value, values?.end);
                    widget.onDateRangeChanged(values);
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
                IconButton(
                  onPressed: () {
                    startController.text = '';
                    values = Ranges(null, values?.end);
                    widget.onDateRangeChanged(values);
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: BoxWInput(
                    controller: endController,
                    title: 'Đến'.tr,
                    readOnly: true,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final value = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );

                    endController.text = value?.toddMMyyyy() ?? '';
                    values = values?.copyWith(end: value);
                    values = Ranges(values?.start, value);
                    widget.onDateRangeChanged(values);
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
                IconButton(
                  onPressed: () {
                    endController.text = '';
                    values = Ranges(values?.start, null);
                    widget.onDateRangeChanged(values);
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
