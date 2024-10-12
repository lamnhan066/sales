import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/domain/entities/ranges.dart';

class ReportFilterDialog extends StatefulWidget {
  const ReportFilterDialog({
    super.key,
    required this.initialDateRange,
    required this.onDateRangeChanged,
  });

  final Ranges<DateTime> initialDateRange;
  final void Function(Ranges<DateTime> value) onDateRangeChanged;

  @override
  State<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends State<ReportFilterDialog> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  late Ranges<DateTime> values;

  @override
  void initState() {
    values = widget.initialDateRange;
    startController.text = values.start.toddMMyyyy();
    endController.text = values.end.toddMMyyyy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Text('Lọc theo khoảng thời gian'.tr),
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

                    if (value != null) {
                      startController.text = value.toddMMyyyy();
                      values = Ranges(value, values.end);
                      widget.onDateRangeChanged(values);
                    }
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
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

                    if (value != null) {
                      endController.text = value.toddMMyyyy();
                      values = values.copyWith(end: value);
                      values = Ranges(values.start, value);
                      widget.onDateRangeChanged(values);
                    }
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
