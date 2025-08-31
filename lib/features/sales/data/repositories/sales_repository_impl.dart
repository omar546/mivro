import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../domain/entities/sale.dart';
import '../../domain/repositories/sales_repository.dart';
import '../data source/sales_local_data_source.dart';
import '../models/sale_model.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesLocalDataSource localDataSource;
  final InventoryRepository inventoryRepository;

  SalesRepositoryImpl(this.localDataSource, this.inventoryRepository);

  @override
  Future<void> addSale(Sale sale) async {
    final model = SaleModel(
      id: sale.id,
      productId: sale.productId,
      quantity: sale.quantity,
      totalPrice: sale.totalPrice,
      date: sale.date,
    );
    await localDataSource.addSale(model);

    // Decrease stock
    final products = await inventoryRepository.getProducts();
    final product = products.firstWhere((p) => p.id == sale.productId);
    final updatedProduct = product.copyWith(
      quantity: product.quantity - sale.quantity,
    );
    await inventoryRepository.updateProduct(updatedProduct);
  }

  @override
  Future<List<Sale>> getSales() async {
    final salesModels = await localDataSource.getSales();
    final sales =
        salesModels
            .map(
              (model) => Sale(
                id: model.id,
                productId: model.productId,
                quantity: model.quantity,
                totalPrice: model.totalPrice,
                date: model.date,
              ),
            )
            .toList();
    return sales;
  }

  @override
  Future<void> deleteSale(String saleId) async {
    await localDataSource.deleteSale(saleId);
  }
}
