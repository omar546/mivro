import 'package:hive/hive.dart';
import '../models/product_model.dart';

class InventoryLocalDataSource {
  final Box<ProductModel> box;

  InventoryLocalDataSource(this.box);

  Future<void> addProduct(ProductModel product) async {
    await box.put(product.id, product);
  }

  Future<void> deleteProduct(String id) async {
    await box.delete(id);
  }

  Future<void> updateProduct(ProductModel product) async {
    await box.put(product.id, product);
  }

  Future<List<ProductModel>> getProducts() async {
    return box.values.toList();
  }
}
