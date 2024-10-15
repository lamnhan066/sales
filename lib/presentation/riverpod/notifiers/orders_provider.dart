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
import 'package:sales/domain/usecases/order_with_items/add_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_next_order_item_id_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/get_order_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/remove_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/order_with_items/update_order_with_items_usecase.dart';
import 'package:sales/domain/usecases/orders/get_next_order_id_usecase.dart';
import 'package:sales/domain/usecases/orders/get_orders_usecase.dart';
import 'package:sales/domain/usecases/products/get_all_products_usecase.dart';
import 'package:sales/presentation/riverpod/states/orders_state.dart';

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
  );
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetOrderItemsUseCase _getOrderItemsUseCase;
  final GetNextOrderIdUseCase _getNextOrderIdUseCase;
  final GetNextOrderItemIdUseCase _getNextOrderItemIdUseCase;
  final AddOrderWithItemsUseCase _addOrderWithItemsUseCase;
  final UpdateOrderWithItemsUseCase _updateOrderWithItemsUseCase;
  final RemoveOrderWithItemsUseCase _removeOrderWithItemsUseCase;
  final GetItemPerPageUseCase _getItemPerPageUseCase;

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
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrderItemsUseCase = getOrderItemsUseCase,
        _getAllProductsUseCase = getAllProductsUseCase,
        _getNextOrderIdUseCase = getNextOrderIdUseCase,
        _getNextOrderItemIdUseCase = getNextOrderItemIdUseCase,
        _addOrderWithItemsUseCase = addOrderWithItemsUseCase,
        _updateOrderWithItemsUseCase = updateOrderWithItemsUseCase,
        _removeOrderWithItemsUseCase = removeOrderWithItemsUseCase,
        _getItemPerPageUseCase = getItemPerPageUseCase,
        super(OrdersState(tour: FeaturesTourController('OrdersView')));

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    await fetchOrders(resetPage: true);
    state = state.copyWith(isLoading: false);
  }

  Future<void> fetchOrders({bool resetPage = false}) async {
    int perpage = await _getItemPerPageUseCase(NoParams());
    int page = state.page;
    if (resetPage) page = 1;

    state = state.copyWith(page: page, perPage: perpage);
    String error = '';
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
}
