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
}

extension CategoryExtension on List<Category> {
  Category fromId(int id) {
    return singleWhere((c) => c.id == id);
  }
}
