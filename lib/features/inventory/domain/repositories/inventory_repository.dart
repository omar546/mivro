import '../entities/category.dart';
import '../entities/product.dart';

abstract class InventoryRepository {
  Future<void> addProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<void> updateProduct(Product product);
  Future<List<Product>> getProducts();

  Future<List<Category>> getCategories();
  Future<void> addCategory(Category category);
  Future<void> deleteCategory(String name);
}
