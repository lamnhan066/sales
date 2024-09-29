import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'imagePath': imagePath,
      'importPrice': importPrice,
      'count': count,
      'description': description,
      'categoryId': categoryId,
      'deleted': deleted,
    };
  }

  Map<String, dynamic> toSqlMap() {
    return {
      'p_id': id,
      'p_sku': sku,
      'p_name': name,
      'p_image_path': imagePath,
      'p_import_price': importPrice,
      'p_count': count,
      'p_description': description,
      'p_category_id': categoryId,
      'p_deleted': deleted,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      sku: map['sku'] ?? '',
      name: map['name'] ?? '',
      imagePath: List<String>.from(map['imagePath']),
      importPrice: map['importPrice']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
      description: map['description'] ?? '',
      categoryId: map['categoryId']?.toInt() ?? 0,
      deleted: map['deleted'] ?? false,
    );
  }

  factory Product.fromSqlMap(Map<String, dynamic> map) {
    return Product(
      id: map['p_id']?.toInt() ?? 0,
      sku: map['p_sku'] ?? '',
      name: map['p_name'] ?? '',
      imagePath: List<String>.from(map['p_image_path']),
      importPrice: map['p_import_price']?.toInt() ?? 0,
      count: map['p_count']?.toInt() ?? 0,
      description: map['p_description'] ?? '',
      categoryId: map['p_category_id']?.toInt() ?? 0,
      deleted: map['p_deleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
