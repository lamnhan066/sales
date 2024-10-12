import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportProvider.notifier).loadReportData();
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
            child: _buildProductReport(context, notifier, state),
          ),
          _buildRevenueReport(context, notifier, state),
        ],
      ),
    );
  }

  Toolbar _buildToolbar(BuildContext context, ReportNotifier notifier, ReportState state) {
    return Toolbar(
      trailings: [
        IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: () => _updateFilters(context, notifier, state),
          icon: const Icon(Icons.calendar_month_rounded),
        ),
      ],
    );
  }

  Widget _buildProductReport(BuildContext context, ReportNotifier notifier, ReportState state) {
    final data = state.soldProductsWithQuantity.entries;
    return Column(
      children: [
        Text('Sản phẩm và số lượng bán tương ứng:'.tr),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final entry = data.elementAt(index);
              return Text('${entry.key.name} - ${entry.value}');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueReport(BuildContext context, ReportNotifier notifier, ReportState state) {
    return Column(
      children: [
        Text('Doanh thu và lợi nhuận:'.tr),
        Text('Doanh thu: ${state.revenue}'),
        Text('Lợi nhuận: ${state.profit}'),
      ],
    );
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

    if (result == true) {
      await notifier.updateFilters(newDateRange);
    }
  }
}
