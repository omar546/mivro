import '../entities/sale.dart';

abstract class SalesRepository {
  Future<void> addSale(Sale sale);
  Future<List<Sale>> getSales();
  Future<void> deleteSale(String saleId);
}
