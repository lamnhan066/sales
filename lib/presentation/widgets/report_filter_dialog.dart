import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/entities/report_date_range_type.dart';

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
  ReportDateRangeType _dateRangeType = ReportDateRangeType.week;
  late Ranges<DateTime> _dateRange;

  @override
  void initState() {
    _dateRange = widget.initialDateRange;
    _dateRangeType = switch (_dateRange) {
      WeekDaysRanges _ => ReportDateRangeType.week,
      MonthDaysRanges _ => ReportDateRangeType.month,
      _ => ReportDateRangeType.custom,
    };
    startController.text = _dateRange.start.toddMMyyyy();
    endController.text = _dateRange.end.toddMMyyyy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Lọc theo khoảng thời gian'.tr,
          style: const TextStyle(fontSize: 18),
        ),
        RadioListTile<ReportDateRangeType>(
          title: Text('Tuần hiện tại'.tr),
          value: ReportDateRangeType.week,
          groupValue: _dateRangeType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _dateRangeType = value;
              });
              _changeDateRange(WeekDaysRanges(DateTime.now()));
            }
          },
        ),
        RadioListTile<ReportDateRangeType>(
          title: Text('Tháng hiện tại'.tr),
          value: ReportDateRangeType.month,
          groupValue: _dateRangeType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _dateRangeType = value;
              });
              _changeDateRange(MonthDaysRanges(DateTime.now()));
            }
          },
        ),
        RadioListTile<ReportDateRangeType>(
          title: Text('Tuỳ chọn'.tr),
          value: ReportDateRangeType.custom,
          groupValue: _dateRangeType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _dateRangeType = value;
              });
            }
          },
        ),
        if (_dateRangeType == ReportDateRangeType.custom) ...[
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
                    _changeDateRange(Ranges(value, _dateRange.end));
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
                    _changeDateRange(Ranges(_dateRange.start, value));
                  }
                },
                icon: const Icon(Icons.calendar_month_rounded),
              ),
            ],
          )
        ]
      ],
    );
  }

  void _changeDateRange(Ranges<DateTime> range) {
    _dateRange = range;
    startController.text = _dateRange.start.toddMMyyyy();
    endController.text = _dateRange.end.toddMMyyyy();
    widget.onDateRangeChanged(_dateRange);
  }
}
