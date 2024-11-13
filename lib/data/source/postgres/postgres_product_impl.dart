import 'package:postgres/postgres.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/product_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';

class PostgresProductImpl implements ProductDatabaseRepository {
  const PostgresProductImpl(this._core);

  final CoreDatabaseRepository _core;
  Connection get _connection => (_core as PostgresCoreImpl).connection;

  @override
  Future<void> addAllProducts(List<ProductModel> products) async {
    const sql = 'SELECT 1 FROM products WHERE p_id = @id';
    for (final product in products) {
      final result = await _connection.execute(Sql.named(sql), parameters: {'id': product.id});
      if (result.isEmpty) {
        await addProduct(product);
      } else {
        await updateProduct(product);
      }
    }
  }

  @override
  Future<void> addProduct(ProductModel product, [Session? session]) async {
    const sql =
        'INSERT INTO products (p_sku, p_name, p_image_path, p_import_price, p_unit_sale_price, p_count, p_description, p_category_id, p_deleted) VALUES (@sku, @name, @imagePath, @importPrice, @unitSalePrice, @count, @description, @categoryId, @deleted)';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'sku': product.sku,
        'name': product.name,
        'imagePath': TypedValue(Type.varCharArray, product.imagePath),
        'importPrice': product.importPrice,
        'unitSalePrice': product.unitSalePrice,
        'count': product.count,
        'description': product.description,
        'categoryId': product.categoryId,
        'deleted': product.deleted,
      },
    );
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    const sql = 'SELECT * FROM products';
    final result = await _connection.execute(Sql.named(sql));

    return result.map((e) => ProductModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<({int id, String sku})> getNextProductIdSku() async {
    const sql = 'SELECT last_value FROM products_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int? ?? 0;
    final id = count + 1;

    return (id: id, sku: 'P${id.toString().padLeft(8, '0')}');
  }

  @override
  Future<ProductModel> getProductById(int id, [Session? session]) async {
    const sql = 'SELECT * FROM products WHERE p_id = @id';
    final result = await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {'id': id},
    );
    return ProductModel.fromMap(result.first.toColumnMap());
  }

  @override
  Future<GetResult<ProductModel>> getProducts([GetProductParams params = const GetProductParams()]) async {
    var sql = 'FROM products WHERE p_deleted=FALSE';
    final parameters = <String, Object>{};

    if (params.isUseCategoryFilter) {
      sql += ' AND p_category_id = @categoryId';
      parameters.addAll({'categoryId': params.categoryIdFilter});
    }

    if (params.isUsePriceRangeFilter) {
      if (params.priceRange.start > 0 && params.priceRange.start != double.infinity) {
        sql += ' AND p_import_price >= @minValue';
        parameters.addAll({
          'minValue': params.priceRange.start.toInt(),
        });
      }

      if (params.priceRange.end > 0 && params.priceRange.end != double.infinity) {
        sql += ' AND p_import_price <= @maxValue';
        parameters.addAll({
          'maxValue': params.priceRange.end.toInt(),
        });
      }
    }

    // TODO(lamnhan066): Tìm cách normalize trước khi query để hiển thị kết quả tốt hơn
    if (params.searchText.isNotEmpty) {
      sql += ' AND LOWER(p_name) LIKE LOWER(@searchText)';
      parameters.addAll({'searchText': '%${params.searchText}%'});
    }

    // Lấy tổng số sản phẩm.
    final countResult = await _connection.execute(Sql.named('SELECT COUNT(*) $sql'), parameters: parameters);
    final totalCount = countResult.first.first! as int;

    sql += ' ORDER BY ${params.orderBy.sql} LIMIT @limit OFFSET @offset';
    parameters.addAll({
      'limit': params.perPage,
      'offset': (params.page - 1) * params.perPage,
    });

    // Lấy danh sách sản phẩm cho trang hiện tại.
    final result = await _connection.execute(Sql.named('SELECT * $sql'), parameters: parameters);
    final products = result.map((e) => ProductModel.fromMap(e.toColumnMap())).toList();

    return GetResult(
      totalCount: totalCount,
      items: products,
    );
  }

  @override
  Future<int> getTotalProductCount() async {
    const sql = 'SELECT count(*) FROM products WHERE p_deleted = FALSE';
    final result = await _connection.execute(sql);

    return result.first.first as int? ?? 0;
  }

  @override
  Future<void> removeProduct(ProductModel product, [Session? session]) async {
    await updateProduct(product.copyWith(deleted: true), session);
  }

  @override
  Future<void> updateProduct(ProductModel product, [Session? session]) async {
    const sql = '''
    UPDATE 
        products 
    SET 
        p_sku = @sku, p_name = @name, p_image_path = @imagePath, p_import_price = @importPrice, p_unit_sale_price = @unitSalePrice, p_count = @count, p_description = @description, p_category_id = @categoryId, p_deleted = @deleted
    WHERE 
        p_id=@id
    ''';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'id': product.id,
        'sku': product.sku,
        'name': product.name,
        'imagePath': TypedValue(Type.varCharArray, product.imagePath),
        'importPrice': product.importPrice,
        'unitSalePrice': product.unitSalePrice,
        'count': product.count,
        'description': product.description,
        'categoryId': product.categoryId,
        'deleted': product.deleted,
      },
    );
  }
}
