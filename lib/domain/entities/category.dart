import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Loại hàng.
class Category with EquatableMixin {
  /// Id.
  final int id;

  /// Tên.
  final String name;

  /// Mô tả.
  final String description;

  /// Xoá.
  final bool deleted;

  /// Loại hàng.
  Category({
    required this.id,
    required this.name,
    required this.description,
    this.deleted = false,
  });

  /// Chuyển từ Map sang Category.
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: (map['name'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      deleted: (map['deleted'] as bool?) ?? false,
    );
  }

  /// Chuyển từ json sang Category.
  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  Category copyWith({
    int? id,
    String? name,
    String? description,
    bool? deleted,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      deleted: deleted ?? this.deleted,
    );
  }

  /// Chuyển sang Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deleted': deleted,
    };
  }

  /// Chuyển sang Json.
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, deleted: $deleted)';
  }

  @override
  List<Object> get props => [id, name, description, deleted];
}

/// Extension của List<Category>.
extension CategoryExtension on List<Category> {
  /// Lấy loại hàng từ id.
  Category fromId(int id) {
    return singleWhere((c) => c.id == id);
  }
}
