import 'package:boxw/boxw.dart';
import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart' hide DataCell, DataColumn, DataRow, DataTable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/price_extensions.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/presentation/riverpod/notifiers/discount_provider.dart';
import 'package:sales/presentation/riverpod/states/discount_state.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';
import 'package:sales/presentation/widgets/discount_dialogs.dart';
import 'package:sales/presentation/widgets/page_chooser_dialog.dart';
import 'package:sales/presentation/widgets/toolbar.dart';

class DiscountView extends ConsumerStatefulWidget {
  const DiscountView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscountViewState();
}

class _DiscountViewState extends ConsumerState<DiscountView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discountProvider.notifier).initialize();
      ref.read(discountProvider).tour.start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discountProvider);
    final notifier = ref.read(discountProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          Toolbar(
            leadings: [
              FeaturesTour(
                controller: state.tour,
                index: 1,
                introduce: Text('Nhấn vào đây để thêm mã giảm giá'.tr),
                child: Tooltip(
                  message: 'Thêm khuyến mãi'.tr,
                  child: FilledButton(
                    onPressed: () => addDiscount(context, notifier),
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 68,
                  columnSpacing: 30,
                  horizontalMargin: 10,
                  columns: _buildColumns(),
                  rows: _buildRows(context, state, notifier),
                ),
              ),
            ),
          ),
          _buildPaginationControls(context, state, notifier),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      headerTextColumn('STT'.tr),
      IntrinsicDataColumn(
        flex: 1,
        headingRowAlignment: MainAxisAlignment.center,
        label: Text(
          'Mã'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      headerTextColumn('Phần trăm'.tr),
      headerTextColumn('Tối đa'.tr),
      headerTextColumn('Hành động'.tr),
    ];
  }

  List<DataRow> _buildRows(BuildContext context, DiscountState state, DiscountNotifier notifier) {
    return state.discounts.asMap().entries.map((entry) {
      final index = entry.key;
      final discount = entry.value;

      return DataRow(
        cells: [
          DataCell(
            Center(
              child: Text(
                '${(state.page - 1) * state.perPage + index + 1}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                discount.code,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                '${discount.percent}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                discount.hasMaxPrice ? discount.maxPrice.toPriceDigit() : 'Không'.tr,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FeaturesTour(
                    enabled: index == 0,
                    controller: state.tour,
                    index: 2,
                    introduce: Text('Nhấn vào đây để chép mã giảm giá'.tr),
                    child: IconButton(
                      onPressed: () {
                        copyDiscount(context, notifier, discount);
                      },
                      icon: const Icon(Icons.copy_rounded),
                    ),
                  ),
                  FeaturesTour(
                    enabled: index == 0,
                    controller: state.tour,
                    index: 3,
                    introduce: Text('Nhấn vào đây để xoá mã giảm giá'.tr),
                    child: IconButton(
                      onPressed: () {
                        removeDiscount(context, notifier, discount);
                      },
                      icon: const Icon(Icons.close_rounded, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildPaginationControls(BuildContext context, DiscountState state, DiscountNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: state.page == 1 ? null : () => notifier.goToPreviousPage(),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          TextButton(
            onPressed: () => choosePage(notifier, state),
            child: Text('${state.page}/${state.totalPage}'),
          ),
          IconButton(
            onPressed: state.page == state.totalPage ? null : () => notifier.goToNextPage(),
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  Future<void> addDiscount(BuildContext context, DiscountNotifier notifier) async {
    await addDiscountDialog(context, notifier);
  }

  Future<void> copyDiscount(BuildContext context, DiscountNotifier notifier, Discount discount) async {
    await notifier.copyDiscount(discount);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã sao chép mã: @{code}'.trP({'code': discount.code}))),
      );
    }
  }

  Future<void> removeDiscount(BuildContext context, DiscountNotifier notifier, Discount discount) async {
    final confirmed = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá mã giảm giá @{code} không?'.trP({
        'code': discount.code,
      }),
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (confirmed) await notifier.removeDiscount(discount);
  }

  Future<void> choosePage(DiscountNotifier notifier, DiscountState state) async {
    final newPage = await pageChooser(
      context: context,
      page: state.page,
      totalPage: state.totalPage,
    );

    if (newPage != null) {
      await notifier.goToPage(newPage);
    }
  }
}
