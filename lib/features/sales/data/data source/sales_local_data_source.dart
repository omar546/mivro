import 'package:hive/hive.dart';

import '../models/sale_model.dart';

class SalesLocalDataSource {
  final Box<SaleModel> box;

  SalesLocalDataSource(this.box);

  Future<void> addSale(SaleModel sale) async {
    await box.put(sale.id, sale);
  }

  Future<List<SaleModel>> getSales() async {
    return box.values.toList();
  }

  Future<void> deleteSale(String saleId) async {
    final box = await Hive.openBox<SaleModel>('sales');
    await box.delete(saleId);
  }
}
