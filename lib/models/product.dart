class Product {
  final int id;
  final String sku;
  final String name;
  final int importPrice;
  final int count;
  final String description;
  final int categoryId;
  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.importPrice,
    required this.count,
    required this.description,
    required this.categoryId,
  });
}
