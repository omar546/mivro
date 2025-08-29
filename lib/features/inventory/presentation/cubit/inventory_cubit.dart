import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository repository;

  InventoryCubit(this.repository) : super(InventoryInitial());

  Future<void> loadProducts() async {
    emit(InventoryLoading());
    final products = await repository.getProducts();
    emit(InventoryLoaded(products));
  }

  Future<void> addProduct(Product product) async {
    await repository.addProduct(product);
    loadProducts();
  }

  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await repository.updateProduct(product);
    loadProducts();
  }
}
