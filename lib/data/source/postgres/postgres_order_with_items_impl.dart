import 'package:postgres/postgres.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/order_with_items_model.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/order_database_repository.dart';
import 'package:sales/data/repositories/order_item_database_repository.dart';
import 'package:sales/data/repositories/order_with_items_database_repository.dart';
import 'package:sales/data/repositories/product_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/data/source/postgres/postgres_order_impl.dart';
import 'package:sales/data/source/postgres/postgres_order_item_impl.dart';
import 'package:sales/data/source/postgres/postgres_product_impl.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';

class PostgresOrderWithItemsImpl implements OrderWithItemsDatabaseRepository {
  const PostgresOrderWithItemsImpl(
    CoreDatabaseRepository core,
    ProductDatabaseRepository product,
    OrderDatabaseRepository order,
    OrderItemDatabaseRepository orderItem,
  )   : _core = core as PostgresCoreImpl,
        _product = product as PostgresProductImpl,
        _order = order as PostgresOrderImpl,
        _orderItem = orderItem as PostgresOrderItemImpl;

  final PostgresCoreImpl _core;
  final PostgresProductImpl _product;
  final PostgresOrderImpl _order;
  final PostgresOrderItemImpl _orderItem;
  Connection get _connection => _core.connection;

  @override
  Future<void> addAllOrdersWithItems(List<OrderWithItemsParamsModel> orderWithItems) async {
    for (final item in orderWithItems) {
      await addOrderWithItems(item);
    }
  }

  @override
  Future<int> addOrderWithItems(OrderWithItemsParamsModel params) async {
    final orderId = await _order.addOrder(params.order);
    for (var orderItem in params.orderItems) {
      orderItem = orderItem.copyWith(orderId: orderId);
      await _orderItem.addOrderItem(orderItem);

      // Cập nhật lại số lượng của sản phẩm.
      var product = await _product.getProductById(orderItem.productId);
      product = product.copyWith(count: product.count - orderItem.quantity);
      await _product.updateProduct(product);
    }
    return orderId;
  }

  @override
  Future<List<OrderWithItemsParamsModel>> getAllOrdersWithItems() async {
    const sql = '''
      SELECT
          *
      FROM
          orders
      JOIN
          order_items on oi_order_id = o_id
    ''';

    final result = await _connection.execute(sql);
    final data = <OrderWithItemsParamsModel>[];
    for (final row in result) {
      final map = row.toColumnMap();
      final orderModel = OrderModel.fromMap(map);
      final orderItemModel = OrderItemModel.fromMap(map);

      OrderWithItemsParamsModel? item;
      for (var i = 0; i < data.length; i++) {
        if (data[i].order == orderModel) {
          item = data[i];
          break;
        }
      }

      if (item != null) {
        item.orderItems.add(orderItemModel);
      } else {
        data.add(OrderWithItemsParamsModel(order: orderModel, orderItems: [orderItemModel]));
      }
    }

    return data;
  }

  @override
  Future<void> removeOrderWithItems(OrderModel order) async {
    await _connection.runTx((session) async {
      final orderItems = await _orderItem.getOrderItems(GetOrderItemsParams(orderId: order.id), session);
      for (final orderItem in orderItems) {
        final tempOrderItems = orderItem.copyWith(deleted: true);
        await _orderItem.updateOrderItem(tempOrderItems, session);

        // Cập nhật lại số lượng sản phẩm.
        var product = await _product.getProductById(orderItem.productId, session);
        product = product.copyWith(count: product.count + orderItem.quantity);
        await _product.updateProduct(product, session);
      }
      await _order.removeOrder(order, session);
    });
  }

  @override
  Future<void> updateOrderWithItems(OrderWithItemsParamsModel params) async {
    await _connection.runTx((session) async {
      await _order.updateOrder(params.order, session);
      final orderItemsFromDatabase = await _orderItem.getOrderItems(
        GetOrderItemsParams(orderId: params.order.id),
        session,
      );

      // Thêm và chỉnh sửa chi tiết đơn hàng
      for (final orderItem in params.orderItems) {
        final index = orderItemsFromDatabase.indexWhere((e) => e.id == orderItem.id);
        if (index == -1) {
          await _orderItem.addOrderItem(orderItem, session);

          // Cập nhật lại số lượng sản phẩm.
          var product = await _product.getProductById(orderItem.productId, session);
          product = product.copyWith(count: product.count - orderItem.quantity);
          await _product.updateProduct(product, session);
        } else {
          await _orderItem.updateOrderItem(orderItem, session);

          // Cập nhật lại số lượng sản phẩm.
          final databaseCount = orderItemsFromDatabase[index].quantity;
          final newCount = orderItem.quantity;
          final differentCount = databaseCount - newCount;
          var product = await _product.getProductById(orderItem.productId, session);
          product = product.copyWith(count: product.count + differentCount);
          await _product.updateProduct(product, session);
        }
      }

      // Xoá chi tiết đơn hàng
      for (final orderItem in orderItemsFromDatabase) {
        final index = params.orderItems.indexWhere((e) => e.id == orderItem.id);
        if (index == -1) {
          await _orderItem.removeOrderItem(orderItem);

          // Cập nhật lại số lượng sản phẩm.
          var product = await _product.getProductById(orderItem.productId);
          product = product.copyWith(count: product.count + orderItem.quantity);
          await _product.updateProduct(product);
        }
      }
    });
  }
}
