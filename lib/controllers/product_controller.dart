import 'package:sales/di.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/services/database/database.dart';

class ProductController {
  final database = getIt<Database>();
  List<Product> products = [];
  int totalProductsCount = 0;

  final int perpage = 10;
  int page = 0;
  ProductOrderBy orderBy = ProductOrderBy.none;
  String filter = '';

  int totalPage = 0;

  Future<void> initial(Function setState) async {
    database.getTotalProductsCount().then((value) {
      setState(() {
        totalProductsCount = value;
        totalPage = (totalProductsCount / perpage).round();
        // Nếu tồn tại số dư thì số trang được cộng thêm 1 vì tôn tại trang có
        // ít hơn `_perpage` sản phẩm.
        if (totalProductsCount % perpage != 0) {
          totalPage += 1;
        }
      });
    });
    database.getProducts(page: 0).then((value) {
      setState(() {
        products = value;
      });
    });
  }

  Future<void> onSeachChanged(Function setState, String text) async {
    filter = text;
    final p = await database.getProducts(perpage: perpage, filter: text);
    setState(() {
      products = p;
    });
  }

  Future<void> onFilterChanged(
      Function setState, ProductOrderBy orderBy) async {
    setState(() {
      this.orderBy = orderBy;
    });
  }
}
