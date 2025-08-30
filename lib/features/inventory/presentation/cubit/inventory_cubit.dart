// inventory_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository repository;

  InventoryCubit(this.repository) : super(InventoryState());

  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await repository.getProducts();
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addProduct(Product product) async {
    await repository.addProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await repository.updateProduct(product);
    await loadProducts();
  }

  Future<void> loadCategories() async {
    try {
      var categories = await repository.getCategories();
      if (categories.isEmpty) {
        final defaultCategory = Category(name: "Uncategorized");
        await repository.addCategory(defaultCategory);
        categories = [defaultCategory];
      }
      emit(state.copyWith(categories: categories));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> addCategory(Category category) async {
    await repository.addCategory(category);
    await loadCategories();
  }

  Future<void> deleteCategory(String name) async {
    await repository.deleteCategory(name);
    await loadCategories();
  }
}
