import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/services/database/database.dart';

/// Controller cho màn hình dashboard
class DashboardController {
  final _database = getIt<Database>();

  /// Tổng tất cả sản phẩm.
  int totalProductCount = 0;

  /// Năm sản phẩm có số lượng trong kho thấp (< 5).
  List<Product> fiveLowStockProducts = [];

  /// Năm sản phẩm bán chạy nhất.
  List<Product> fiveHighestSalesProducts = [];

  /// Số đơn hàng bán hằng ngày.
  int dailyOrderCount = 0;

  /// Doanh thu hằng ngày.
  int dailyRevenue = 0;

  /// Ba đơn hàng gần nhất.
  ({
    Map<Order, List<OrderItem>> orderItems,
    Map<Order, List<Product>> products
  }) threeRecentOrders = (
    orderItems: <Order, List<OrderItem>>{},
    products: <Order, List<Product>>{}
  );

  /// Doanh thu hằng tháng.
  List<int> monthlyRevenues = [];

  /// Khởi tạo.
  Future<void> initial(void Function(void Function()) setState) async {
    await Future.wait([
      _database.getTotalProductCount().then((value) {
        setState(() {
          totalProductCount = value;
        });
      }),
      _database.getFiveLowStockProducts().then((value) {
        setState(() {
          fiveLowStockProducts = value;
        });
      }),
      _database.getFiveHighestSalesProducts().then((value) {
        setState(() {
          fiveHighestSalesProducts = value;
        });
      }),
      _database.getDailyOrderCount(DateTime.now()).then((value) {
        setState(() {
          dailyOrderCount = value;
        });
      }),
      _database.getDailyRevenue(DateTime.now()).then((value) {
        setState(() {
          dailyRevenue = value;
        });
      }),
      _database.getThreeRecentOrders().then((value) {
        setState(() {
          threeRecentOrders = value;
        });
      }),
      _database.getMonthlyRevenues(DateTime.now()).then((values) {
        setState(() {
          monthlyRevenues = values;
        });
      }),
    ]);
  }
}
