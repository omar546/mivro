import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
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
}
