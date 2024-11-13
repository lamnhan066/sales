import 'package:features_tour/features_tour.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/usecases/app/get_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/app/print_image_bytes_as_pdf_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/add_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_next_order_item_id_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_order_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_temporary_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/remove_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/remove_temporary_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/save_temporary_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/update_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/orders/get_next_order_id_usecase.dart';
import 'package:sales/domain/usecases/orders/get_orders_usecase.dart';
import 'package:sales/domain/usecases/products/get_all_products_usecase.dart';
import 'package:sales/presentation/riverpod/states/orders_state.dart';
import 'package:screenshot/screenshot.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(
    getOrdersUseCase: getIt(),
    getAllProductsUseCase: getIt(),
    getOrderItemsUseCase: getIt(),
    getNextOrderIdUseCase: getIt(),
    getNextOrderItemIdUseCase: getIt(),
    addOrderWithItemsUseCase: getIt(),
    updateOrderWithItemsUseCase: getIt(),
    removeOrderWithItemsUseCase: getIt(),
    getItemPerPageUseCase: getIt(),
    getTemporaryOrderWithItemsUseCase: getIt(),
    saveTemporaryOrderWithItemsUseCase: getIt(),
    removeTemporaryOrderWithItemsUseCase: getIt(),
    printImageBytesAsPdfUseCase: getIt(),
  );
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier({
    required GetOrdersUseCase getOrdersUseCase,
    required GetAllProductsUseCase getAllProductsUseCase,
    required GetOrderItemsUseCase getOrderItemsUseCase,
    required GetNextOrderIdUseCase getNextOrderIdUseCase,
    required GetNextOrderItemIdUseCase getNextOrderItemIdUseCase,
    required AddOrderWithItemsUseCase addOrderWithItemsUseCase,
    required UpdateOrderWithItemsUseCase updateOrderWithItemsUseCase,
    required RemoveOrderWithItemsUseCase removeOrderWithItemsUseCase,
    required GetItemPerPageUseCase getItemPerPageUseCase,
    required GetTemporaryOrderWithItemsUseCase getTemporaryOrderWithItemsUseCase,
    required SaveTemporaryOrderWithItemsUseCase saveTemporaryOrderWithItemsUseCase,
    required RemoveTemporaryOrderWithItemsUseCase removeTemporaryOrderWithItemsUseCase,
    required PrintImageBytesAsPdfUseCase printImageBytesAsPdfUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrderItemsUseCase = getOrderItemsUseCase,
        _getAllProductsUseCase = getAllProductsUseCase,
        _getNextOrderIdUseCase = getNextOrderIdUseCase,
        _getNextOrderItemIdUseCase = getNextOrderItemIdUseCase,
        _addOrderWithItemsUseCase = addOrderWithItemsUseCase,
        _updateOrderWithItemsUseCase = updateOrderWithItemsUseCase,
        _removeOrderWithItemsUseCase = removeOrderWithItemsUseCase,
        _getItemPerPageUseCase = getItemPerPageUseCase,
        _getTemporaryOrderWithItemsUseCase = getTemporaryOrderWithItemsUseCase,
        _saveTemporaryOrderWithItemsUseCase = saveTemporaryOrderWithItemsUseCase,
        _removeTemporaryOrderWithItemsUseCase = removeTemporaryOrderWithItemsUseCase,
        _printImageBytesAsPdfUseCase = printImageBytesAsPdfUseCase,
        super(OrdersState(tour: FeaturesTourController('OrdersView'), screenshot: ScreenshotController()));
  final GetOrdersUseCase _getOrdersUseCase;
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetOrderItemsUseCase _getOrderItemsUseCase;
  final GetNextOrderIdUseCase _getNextOrderIdUseCase;
  final GetNextOrderItemIdUseCase _getNextOrderItemIdUseCase;
  final AddOrderWithItemsUseCase _addOrderWithItemsUseCase;
  final UpdateOrderWithItemsUseCase _updateOrderWithItemsUseCase;
  final RemoveOrderWithItemsUseCase _removeOrderWithItemsUseCase;
  final GetItemPerPageUseCase _getItemPerPageUseCase;
  final GetTemporaryOrderWithItemsUseCase _getTemporaryOrderWithItemsUseCase;
  final SaveTemporaryOrderWithItemsUseCase _saveTemporaryOrderWithItemsUseCase;
  final RemoveTemporaryOrderWithItemsUseCase _removeTemporaryOrderWithItemsUseCase;
  final PrintImageBytesAsPdfUseCase _printImageBytesAsPdfUseCase;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    await fetchOrders(resetPage: true);

    final hasDraft = (await getTemporaryOrderWithItems()) != null;
    state = state.copyWith(hasDraft: hasDraft, isLoading: false);
  }

  Future<void> fetchOrders({bool resetPage = false}) async {
    final perpage = await _getItemPerPageUseCase(NoParams());
    var page = state.page;
    if (resetPage) page = 1;

    state = state.copyWith(page: page, perPage: perpage);
    var error = '';
    try {
      final result = await _getOrdersUseCase(
        GetOrderParams(page: state.page, perpage: state.perPage, dateRange: state.dateRange),
      );
      state = state.copyWith(
        orders: result.items,
        totalPage: (result.totalCount / state.perPage).ceil(),
        isLoading: false,
      );
    } catch (e) {
      error = e.toString();
    }
    state = state.copyWith(error: error);
  }

  Future<void> goToPreviousPage() async {
    await goToPage(state.page - 1);
  }

  Future<void> goToNextPage() async {
    await goToPage(state.page + 1);
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > state.totalPage) return;

    state = state.copyWith(page: page);
    await fetchOrders();
  }

  /// Nhấn nút lọc.
  Future<void> updateFilters(Ranges<DateTime?>? dateRange) async {
    state = state.updateDateRange(dateRange);
    await fetchOrders();
  }

  Future<List<Product>> getProducts() {
    return _getAllProductsUseCase(NoParams());
  }

  Future<int> getNextOrderItemId() {
    return _getNextOrderItemIdUseCase(NoParams());
  }

  Future<int> getNextOrderId() {
    return _getNextOrderIdUseCase(NoParams());
  }

  Future<List<OrderItem>> getOrderItems(int orderId) {
    return _getOrderItemsUseCase(GetOrderItemsParams(orderId: orderId));
  }

  Future<void> updateOrderWithItems(Order order, List<OrderItem> orderItems) async {
    if (orderItems.isEmpty) {
      await _removeOrderWithItemsUseCase(order);
    } else {
      await _updateOrderWithItemsUseCase(OrderWithItemsParams(order: order, orderItems: orderItems));
    }
    await fetchOrders();
  }

  Future<void> addOrderWithItems(Order order, List<OrderItem> orderItems) async {
    await _addOrderWithItemsUseCase(OrderWithItemsParams(order: order, orderItems: orderItems));
    await fetchOrders();
  }

  Future<void> removeOrderWithItems(Order order) async {
    await _removeOrderWithItemsUseCase(order);
    await fetchOrders();
  }

  Future<void> saveTemporaryOrderWithItems(OrderWithItemsParams params) async {
    await _saveTemporaryOrderWithItemsUseCase(params);
  }

  Future<void> removeTemporaryOrderWithItems() async {
    await _removeTemporaryOrderWithItemsUseCase(NoParams());
  }

  Future<OrderWithItemsParams?> getTemporaryOrderWithItems() async {
    return _getTemporaryOrderWithItemsUseCase(NoParams());
  }

  Future<void> printOrder(double pixelRatio) async {
    final bytes = await state.screenshot.capture(pixelRatio: pixelRatio);
    if (bytes != null) {
      await _printImageBytesAsPdfUseCase(bytes);
    }
  }

  bool canShowDraftDialog() {
    final canShow = state.isShownDraftDialog == false;
    if (!canShow) {
      return false;
    }
    state = state.copyWith(isShownDraftDialog: true);
    return true;
  }

  void closeDraftDialog() {
    state = state.copyWith(isShownDraftDialog: false, hasDraft: false);
  }
}
