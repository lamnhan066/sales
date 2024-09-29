enum ProductOrderBy {
  /// Sắp xếp theo sku tăng dần (Mặc định).
  none,

  /// Sắp xếp theo tên tăng dần.
  nameAsc,

  /// Sắp xếp theo tên giảm dần.
  nameDesc,

  /// Sắp xếp theo giá nhập tăng dần.
  importPriceAsc,

  /// Sắp xếp theo giá nhập giảm dần.
  importPriceDesc,

  /// Sắp xếp theo số lượng tăng dần.
  countAsc,

  /// Sắp xếp theo số lượng giảm dần.
  countDesc
}
