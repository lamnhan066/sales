// ignore_for_file: number_of_parameters
import 'dart:convert';

/// Sản phẩm.
class ProductModel {
  /// Id.
  final int id;

  /// Sku.
  final String sku;

  /// Tên.
  final String name;

  /// Danh sách hình ảnh dạng URL hoặc đường dẫn của tệp.
  final List<String> imagePath;

  /// Giá nhập.
  final int importPrice;

  /// Số lượng.
  final int count;

  /// Mô tả.
  final String description;

  /// Mã loại hàng.
  final int categoryId;

  /// Đánh dấu xoá.
  final bool deleted;

  /// Sản phẩm.
  ProductModel({
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

  /// SQL Map -> Product
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: (map['p_id'] as num).toInt(),
      sku: map['p_sku'] as String,
      name: map['p_name'] as String,
      imagePath: List<String>.from(map['p_image_path'] as List<dynamic>),
      importPrice: (map['p_import_price'] as num).toInt(),
      count: (map['p_count'] as num).toInt(),
      description: map['p_description'] as String,
      categoryId: (map['p_category_id'] as num).toInt(),
      deleted: map['p_deleted'] as bool,
    );
  }

  /// JSON -> Product
  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  ProductModel copyWith({
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
    return ProductModel(
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

  /// Product -> SQL Map.
  Map<String, dynamic> toMap() {
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

  /// Product -> JSON.
  String toJson() => json.encode(toMap());
}
