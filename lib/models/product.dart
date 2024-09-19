class Product {
  final int id;
  final String sku;
  final String name;
  final List<String> imagePath;
  final int importPrice;
  final int count;
  final String description;
  final int categoryId;
  final bool deleted;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.imagePath,
    required this.importPrice,
    required this.count,
    required this.description,
    required this.categoryId,
    this.deleted = false,
  });

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    List<String>? imagePath,
    int? importPrice,
    int? count,
    String? description,
    int? categoryId,
    bool? deleted,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      importPrice: importPrice ?? this.importPrice,
      count: count ?? this.count,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, sku: $sku, name: $name, imagePath: $imagePath, importPrice: $importPrice, count: $count, description: $description, categoryId: $categoryId, deleted: $deleted)';
  }
}
