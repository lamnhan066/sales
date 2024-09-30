enum ProductOrderBy {
  /// Sắp xếp theo sku tăng dần (Mặc định).
  none('p_sku ASC'),

  /// Sắp xếp theo tên tăng dần.
  nameAsc('p_name ASC'),

  /// Sắp xếp theo tên giảm dần.
  nameDesc('p_name DESC'),

  /// Sắp xếp theo giá nhập tăng dần.
  importPriceAsc('p_import_price ASC'),

  /// Sắp xếp theo giá nhập giảm dần.
  importPriceDesc('p_import_price DESC'),

  /// Sắp xếp theo số lượng tăng dần.
  countAsc('p_count ASC'),

  /// Sắp xếp theo số lượng giảm dần.
  countDesc('p_count DESC');

  final String sql;

  const ProductOrderBy(this.sql);
}
