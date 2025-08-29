import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  // Convert to entity
  Product toEntity() => Product(
    id: id,
    name: name,
    price: price,
    quantity: quantity,
    category: category,
  );

  // Convert from entity
  factory ProductModel.fromEntity(Product product) => ProductModel(
    id: product.id,
    name: product.name,
    price: product.price,
    quantity: product.quantity,
    category: product.category,
  );
}
