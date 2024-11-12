import 'package:sales/data/repositories/category_database.dart';
import 'package:sales/data/repositories/core_database.dart';
import 'package:sales/data/repositories/data_sync_database.dart';
import 'package:sales/data/repositories/order_database.dart';
import 'package:sales/data/repositories/order_item_database.dart';
import 'package:sales/data/repositories/order_with_items_database.dart';
import 'package:sales/data/repositories/product_database.dart';
import 'package:sales/data/repositories/report_database.dart';

/// Database abstract.
abstract class Database
    implements
        CoreDatabase,
        DataSyncDatabase,
        ProductDatabase,
        CategoryDatabase,
        OrderDatabase,
        OrderItemDatabase,
        OrderWithItemsDatabase,
        ReportDatabase {}
