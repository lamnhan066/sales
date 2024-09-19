import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/services/database/database.dart';

class DashboardController {
  final database = getIt<Database>();
  int totalProductCount = 0;
  List<Product> fiveLowStockProducts = [];
  List<Product> fiveHighestSalesProducts = [];
  int dailyOrderCount = 0;
  int dailyRevenue = 0;
  var threeRecentOrders =
      (<Order, List<OrderItem>>{}, <Order, List<Product>>{});
  List<int> monthlyRevenues = [];

  Future<void> initial(Function setState) async {
    database.getTotalProductCount().then((value) {
      setState(() {
        totalProductCount = value;
      });
    });
    database.getFiveLowStockProducts().then((value) {
      setState(() {
        fiveLowStockProducts = value;
      });
    });
    database.getFiveHighestSalesProducts().then((value) {
      setState(() {
        fiveHighestSalesProducts = value;
      });
    });
    database.getDailyOrderCount(DateTime.now()).then((value) {
      setState(() {
        dailyOrderCount = value;
      });
    });
    database.getDailyRevenue(DateTime.now()).then((value) {
      setState(() {
        dailyRevenue = value;
      });
    });
    database.getThreeRecentOrders().then((value) {
      setState(() {
        threeRecentOrders = value;
      });
    });
    database.getMonthlyRevenues(DateTime.now()).then((values) {
      monthlyRevenues = values;
    });
  }
}
