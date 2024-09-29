import 'dart:convert';

class Category {
  final int id;
  final String name;
  final String description;
  final bool deleted;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.deleted = false,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deleted': deleted,
    };
  }

  Map<String, dynamic> toSqlMap() {
    return {
      'c_id': id,
      'c_name': name,
      'c_description': description,
      'c_deleted': deleted,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      deleted: map['deleted'] ?? false,
    );
  }

  factory Category.fromSqlMap(Map<String, dynamic> map) {
    return Category(
      id: map['c_id']?.toInt() ?? 0,
      name: map['c_name'] ?? '',
      description: map['c_description'] ?? '',
      deleted: map['c_deleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, deleted: $deleted)';
  }
}

extension CategoryExtension on List<Category> {
  Category fromId(int id) {
    return singleWhere((c) => c.id == id);
  }
}
