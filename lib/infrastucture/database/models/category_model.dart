import 'dart:convert';

/// Loại hàng.
class CategoryModel {
  /// Id.
  final int id;

  /// Tên.
  final String name;

  /// Mô tả.
  final String description;

  /// Xoá.
  final bool deleted;

  /// Loại hàng.
  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.deleted = false,
  });

  /// Chuyển từ SQL Map sang Category.
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: (map['c_id'] as num?)?.toInt() ?? 0,
      name: (map['c_name'] as String?) ?? '',
      description: (map['c_description'] as String?) ?? '',
      deleted: (map['c_deleted'] as bool?) ?? false,
    );
  }

  /// Chuyển từ json sang Category.
  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? deleted,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      deleted: deleted ?? this.deleted,
    );
  }

  /// Chuyển sang dạng Map với key của SQL.
  Map<String, dynamic> toMap() {
    return {
      'c_id': id,
      'c_name': name,
      'c_description': description,
      'c_deleted': deleted,
    };
  }

  /// Chuyển sang Json.
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, deleted: $deleted)';
  }
}
