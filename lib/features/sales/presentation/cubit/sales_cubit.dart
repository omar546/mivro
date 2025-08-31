import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/presentation/cubit/inventory_cubit.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/entities/sale.dart';
part 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  final SalesRepository repository;
  final InventoryCubit inventoryCubit; // reference to update stock

  SalesCubit(this.repository, this.inventoryCubit) : super(SalesInitial());

  Future<void> loadSales() async {
    emit(SalesLoading());
    final sales = await repository.getSales();
    emit(SalesLoaded(sales));
  }

  Future<void> addSale(Sale sale) async {
    await repository.addSale(sale);
    loadSales();
  }

  Future<void> deleteSale(Sale sale, InventoryCubit inventoryCubit) async {
    if (state is SalesLoaded) {
      try {
        // Delete sale from repository
        await repository.deleteSale(sale.id);

        // Increase the product stock
        inventoryCubit.updateProductQuantity(sale.productId, sale.quantity);

        // Update state
        final updatedSales =
            (state as SalesLoaded).sales.where((s) => s.id != sale.id).toList();
        emit(SalesLoaded(updatedSales));
      } catch (e) {
        emit(SalesError("Failed to delete sale"));
      }
    }
  }
}
