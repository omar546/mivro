part of 'inventory_cubit.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<Product> products;
  InventoryLoaded(this.products);
}

class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);
}
