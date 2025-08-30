// inventory_state.dart
part of 'inventory_cubit.dart';

class InventoryState {
  final List<Product> products;
  final List<Category> categories;
  final bool isLoading;
  final String? error;

  InventoryState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  InventoryState copyWith({
    List<Product>? products,
    List<Category>? categories,
    bool? isLoading,
    String? error,
  }) {
    return InventoryState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
