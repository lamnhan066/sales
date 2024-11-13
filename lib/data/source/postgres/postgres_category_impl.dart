import 'package:postgres/postgres.dart';
import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/repositories/category_database_repository.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';

class PostgresCategoryImpl implements CategoryDatabaseRepository {
  PostgresCategoryImpl(this._core);

  final CoreDatabaseRepository _core;
  Connection get _connection => (_core as PostgresCoreImpl).connection;

  @override
  Future<void> addAllCategories(List<CategoryModel> categories) async {
    const sql = 'SELECT 1 FROM categories WHERE c_id = @id';
    await _connection.runTx((session) async {
      for (final category in categories) {
        final result = await session.execute(Sql.named(sql), parameters: {'id': category.id});
        if (result.isEmpty) {
          await addCategory(category, session);
        } else {
          await updateCategory(category, session);
        }
      }
    });
  }

  @override
  Future<void> addCategory(CategoryModel category, [Session? session]) async {
    const sql = 'INSERT INTO categories (c_name, c_description, c_deleted) VALUES (@name, @description, FALSE)';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'name': category.name,
        'description': category.description,
      },
    );
  }

  @override
  Future<List<CategoryModel>> getAllCategories([Session? session]) async {
    const sql = 'SELECT * FROM categories';
    final result = await (session ?? _connection).execute(sql);

    return result.map((e) => CategoryModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<int> getNextCategoryId() async {
    const sql = 'SELECT last_value FROM categories_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int? ?? 0;
    final id = count + 1;

    return id;
  }

  @override
  Future<void> removeCategory(CategoryModel category) async {
    await updateCategory(category.copyWith(deleted: true));
  }

  @override
  Future<void> updateCategory(CategoryModel category, [Session? session]) async {
    const sql =
        'UPDATE categories SET c_name = @name, c_description = @description, c_deleted = @deleted WHERE c_id=@id';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'id': category.id,
        'name': category.name,
        'description': category.description,
        'deleted': category.deleted,
      },
    );
  }
}
