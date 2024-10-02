import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_dialogs.dart';
import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/range_of_dates.dart';
import 'package:sales/services/database/database.dart';

class OrderController {
  final database = getIt<Database>();
  List<Order> orders = [];
  final int perpage = 10;
  int page = 1;
  int totalPage = 0;
  RangeOfDates? dateRange;

  Future<void> initial(void Function(VoidCallback fn) setState) async {
    await database.getOrders(page: 1).then((value) {
      setState(() {
        _updatePagesCountAndList(value.totalCount, value.orders);
      });
    });
  }

  void onPagePrevious(Function setState) async {
    if (page > 1) _changePage(setState, page - 1);
  }

  void onPageNext(Function setState) async {
    if (page < totalPage) _changePage(setState, page + 1);
  }

  void onPageChanged(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    final newPage =
        await pageChooser(context: context, page: page, totalPage: totalPage);

    if (newPage != null) {
      page = newPage;
      _changePage(setState, page);
    }
  }

  void onFilterTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) {}

  void infoOrder(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Order o,
  ) async {
    await _infoOrderDialog(context, setState, o);
  }

  void addOrder(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    final order = await _addOrderDialog(context, setState);

    if (order != null) {
      await database.addOrder(order);
      _updateCurrentPage(setState);
    }
  }

  void editOrder(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Order o,
  ) async {
    final order = await _editOrderDialog(context, setState, o);

    if (order != null) {
      await database.updateOrder(order);
      _updateCurrentPage(setState);
    }
  }

  void copyOrder(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Order o,
  ) async {
    final order = await _copyOrderDialog(context, setState, o);

    if (order != null) {
      await database.addOrder(order);
      _updateCurrentPage(setState);
    }
  }

  void removeOrder(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Order o,
  ) async {
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá đơn này không?'.tr,
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result == true) {
      await database.removeOrder(o);
      _updateCurrentPage(setState);
    }
  }
}

extension PrivateOrderController on OrderController {
  Future<Order?> _infoOrderDialog(
    BuildContext context,
    Function setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Thông Tin Đơn'.tr,
      order: order,
      generateIdSku: true,
      readOnly: true,
    );
  }

  Future<Order?> _addOrderDialog(BuildContext context, Function setState) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Thêm Đơn'.tr,
      order: null,
      generateIdSku: true,
    );
  }

  Future<Order?> _editOrderDialog(
      BuildContext context, Function setState, Order order) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Sửa Đơn'.tr,
      order: order,
      generateIdSku: false,
    );
  }

  Future<Order?> _copyOrderDialog(
      BuildContext context, Function setState, Order order) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Chép Đơn'.tr,
      order: order,
      generateIdSku: true,
    );
  }

  void _changePage(Function setState, int newPage) async {
    page = newPage;
    _updateCurrentPage(setState);
  }

  Future<void> _updateCurrentPage(
    Function setState, {
    bool resetPage = false,
  }) async {
    if (resetPage) page = 1;

    final allOrders = await database.getOrders(
      page: page,
      perpage: perpage,
      dateRange: dateRange,
    );

    setState(() {
      _updatePagesCountAndList(allOrders.totalCount, allOrders.orders);
    });
  }

  void _updatePagesCountAndList(int totalCount, List<Order> o) {
    orders = o;

    totalPage = (totalCount / perpage).floor();
    // Nếu tồn tại số dư thì số trang được cộng thêm 1 vì tôn tại trang có
    // ít hơn `_perpage` sản phẩm.
    if (totalCount % perpage != 0) {
      totalPage += 1;
    }
  }

  Future<Order?> _orderDialog({
    required BuildContext context,
    required Function setState,
    required String title,
    required Order? order,
    required bool generateIdSku,
    bool readOnly = false,
  }) async {
    Order tempOrder = order ??
        Order(
          id: 0,
          status: OrderStatus.created,
          date: DateTime.now(),
          deleted: false,
        );
    if (generateIdSku || order == null) {
      final id = await database.generateCategoryId();
      tempOrder = tempOrder.copyWith(id: id);
    }

    final form = GlobalKey<FormState>();
    final formValidator = StreamController<bool>();

    void validateForm() {
      formValidator.add(form.currentState!.validate());
    }

    if (context.mounted) {
      final result = await boxWDialog(
        context: context,
        title: title,
        width: MediaQuery.sizeOf(context).width * 3 / 5,
        constrains: BoxConstraints(
          minWidth: 280,
          maxWidth: MediaQuery.sizeOf(context).width * 3 / 5,
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 3 / 5,
          ),
          child: Form(
            key: form,
            onChanged: validateForm,
            child: const SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
        buttons: (context) {
          return [
            Buttons(
              axis: Axis.horizontal,
              buttons: [
                StreamBuilder<bool>(
                    stream: formValidator.stream,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: FilledButton(
                          onPressed: !snapshot.hasData || snapshot.data != true
                              ? null
                              : () {
                                  Navigator.pop(context, true);
                                },
                          child: Text('OK'.tr),
                        ),
                      );
                    }),
                if (!readOnly)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Huỷ'.tr),
                    ),
                  ),
              ],
            ),
          ];
        },
      );

      if (result == true) {
        return tempOrder;
      }
    }

    return null;
  }
}