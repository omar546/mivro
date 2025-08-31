import 'package:hive/hive.dart';

@HiveType(typeId: 2) // unique
class SaleModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String productId;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  double totalPrice;

  @HiveField(4)
  DateTime date;

  SaleModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.date,
  });
}
