import 'package:sales/data/database/category_database.dart';
import 'package:sales/data/database/core_database.dart';
import 'package:sales/data/database/data_sync_database.dart';
import 'package:sales/data/database/order_database.dart';
import 'package:sales/data/database/order_item_database.dart';
import 'package:sales/data/database/order_with_items_database.dart';
import 'package:sales/data/database/product_database.dart';
import 'package:sales/data/database/report_database.dart';

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
