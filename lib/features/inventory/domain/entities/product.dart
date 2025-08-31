class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
}
