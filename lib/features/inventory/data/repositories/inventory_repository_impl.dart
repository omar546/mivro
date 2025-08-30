import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl(this.localDataSource);

  @override
  Future<void> addProduct(Product product) async {
    await localDataSource.addProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await localDataSource.deleteProduct(id);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await localDataSource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<List<Product>> getProducts() async {
    final models = await localDataSource.getProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final models = await localDataSource.getCategories();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await localDataSource.addCategory(model);
  }

  @override
  Future<void> deleteCategory(String name) async {
    await localDataSource.deleteCategory(name);
  }
}
