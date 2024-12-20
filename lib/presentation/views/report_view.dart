import 'package:boxw/boxw.dart';
import 'package:features_tour/features_tour.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/core/extensions/price_extensions.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/presentation/riverpod/notifiers/report_provider.dart';
import 'package:sales/presentation/riverpod/states/report_state.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/report_filter_dialog.dart';
import 'package:sales/presentation/widgets/toolbar.dart';

/// Màn hình báo cáo.
class ReportView extends ConsumerStatefulWidget {
  const ReportView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportProvider.notifier).loadReportData();
      ref.read(reportProvider).tour.start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(reportProvider.notifier);
    final state = ref.watch(reportProvider);

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, notifier, state),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProductReport(context, notifier, state),
                  _buildRevenueReport(context, notifier, state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Toolbar _buildToolbar(BuildContext context, ReportNotifier notifier, ReportState state) {
    return Toolbar(
      leadings: [
        Text(_reportTitleText(state)),
      ],
      trailings: [
        FeaturesTour(
          controller: state.tour,
          index: 1,
          introduce: Text('Nhấn vào đây để hiển thị tuỳ chọn bộ lọc cho báo cáo'.tr),
          child: Tooltip(
            message: 'Lọc báo cáo theo thời gian'.tr,
            child: IconButton(
              onPressed: () => _updateFilters(context, notifier, state),
              icon: const Icon(Icons.calendar_month_rounded),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductReport(BuildContext context, ReportNotifier notifier, ReportState state) {
    final data = state.soldProductsWithQuantity.entries;
    return Column(
      children: [
        Text(
          'Sản phẩm và số lượng bán tương ứng:'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: SingleChildScrollView(
            child: DataTable(
              dataRowMinHeight: 68,
              dataRowMaxHeight: 68,
              columnSpacing: 30,
              horizontalMargin: 10,
              columns: _buildDataColumns(),
              rows: [
                for (int i = 0; i < data.length; i++) _buildDataRows(data.elementAt(i)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DataColumn> _buildDataColumns() {
    return <DataColumn>[
      DataColumn(label: Text('Tên Sản Phẩm'.tr)),
      DataColumn(numeric: true, label: Text('Số Lượng'.tr)),
    ];
  }

  DataRow _buildDataRows(MapEntry<Product, int> element) {
    return DataRow(
      cells: [
        DataCell(
          Text(element.key.name),
        ),
        DataCell(
          Text('${element.value}'),
        ),
      ],
    );
  }

  Widget _buildRevenueReport(BuildContext context, ReportNotifier notifier, ReportState state) {
    return Column(
      children: [
        Text(
          'Doanh thu và lợi nhuận:'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${'Doanh thu'.tr}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: state.revenue.toPriceDigit()),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${'Lợi nhuận'.tr}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: state.profit.toPriceDigit()),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Chỉ hiển thị biểu đồ khi thu nhập lớn hơn 0
        if (state.revenue > 0)
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(notifier, state),
              ),
            ),
          ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(ReportNotifier notifier, ReportState state) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(blurRadius: 2)];

      final bigPie = (state.revenue - state.profit) / state.revenue;
      final smallPie = state.profit / state.revenue;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: bigPie,
            title: '${(bigPie * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: smallPie,
            title: '${(smallPie * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  Future<void> _updateFilters(BuildContext context, ReportNotifier notifier, ReportState state) async {
    var newDateRange = state.reportDateRange;
    final result = await boxWDialog<bool>(
      context: context,
      title: 'Bộ lọc'.tr,
      content: ReportFilterDialog(
        initialDateRange: newDateRange,
        onDateRangeChanged: (dateRange) {
          newDateRange = dateRange;
        },
      ),
      buttons: (context) {
        return [
          confirmCancelButtons(
            context: context,
            confirmText: 'OK'.tr,
            cancelText: 'Huỷ'.tr,
          ),
        ];
      },
    );

    if (result ?? false) {
      await notifier.updateFilters(newDateRange);
    }
  }

  String _reportTitleText(ReportState state) {
    return switch (state.reportDateRange) {
      SevenDaysRanges() => 'Báo cáo trong tuần hiện tại từ @{fromDate} đến @{toDate}'.trP({
          'fromDate': state.reportDateRange.start.toddMMyyyy(),
          'toDate': state.reportDateRange.end.toddMMyyyy(),
        }),
      ThirtyDaysRanges() => 'Báo cáo trong tháng hiện tại từ @{fromDate} to @{toDate}'.trP({
          'fromDate': state.reportDateRange.start.toddMMyyyy(),
          'toDate': state.reportDateRange.end.toddMMyyyy(),
        }),
      _ => 'Báo cáo từ @{fromDate} đến @{toDate}'.trP({
          'fromDate': state.reportDateRange.start.toddMMyyyy(),
          'toDate': state.reportDateRange.end.toddMMyyyy(),
        }),
    };
  }
}
