import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivro/core/colors.dart';

import '../../../inventory/domain/entities/product.dart';
import '../../../inventory/presentation/cubit/inventory_cubit.dart';
import '../../domain/entities/sale.dart';
import '../cubit/sales_cubit.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  DateTime? startDate;
  DateTime? endDate;

  List<Sale> _filterSalesByDate(List<Sale> sales) {
    if (startDate == null && endDate == null) return sales;

    return sales.where((sale) {
      final saleDate = DateTime(sale.date.year, sale.date.month, sale.date.day);

      if (startDate != null && endDate != null) {
        final start = DateTime(
          startDate!.year,
          startDate!.month,
          startDate!.day,
        );
        final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
        return saleDate.isAtSameMomentAs(start) ||
            saleDate.isAtSameMomentAs(end) ||
            (saleDate.isAfter(start) && saleDate.isBefore(end));
      } else if (startDate != null) {
        final start = DateTime(
          startDate!.year,
          startDate!.month,
          startDate!.day,
        );
        return saleDate.isAtSameMomentAs(start) || saleDate.isAfter(start);
      } else if (endDate != null) {
        final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
        return saleDate.isAtSameMomentAs(end) || saleDate.isBefore(end);
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<InventoryCubit>().state.products;

    return Scaffold(
      appBar: AppBar(title: const Text("Sales")),
      body: Column(
        children: [
          // Date Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter by Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              startDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                startDate != null
                                    ? "${startDate!.day.toString().padLeft(2, '0')}/${startDate!.month.toString().padLeft(2, '0')}/${startDate!.year}"
                                    : "Start Date",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text("to", style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: startDate ?? DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              endDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                endDate != null
                                    ? "${endDate!.day.toString().padLeft(2, '0')}/${endDate!.month.toString().padLeft(2, '0')}/${endDate!.year}"
                                    : "End Date",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (startDate != null || endDate != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: _clearFilters,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        tooltip: "Clear Filters",
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Sales List
          Expanded(
            child: BlocBuilder<SalesCubit, SalesState>(
              builder: (context, state) {
                if (state is SalesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SalesLoaded) {
                  final filteredSales = _filterSalesByDate(state.sales);

                  if (filteredSales.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            startDate != null || endDate != null
                                ? "No sales found in selected date range"
                                : "No sales recorded yet",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredSales.length,
                    itemBuilder: (context, i) {
                      final sale = filteredSales[i];
                      final product = products.firstWhere(
                        (p) => p.id == sale.productId,
                        orElse:
                            () => Product(
                              id: sale.productId,
                              name: 'Unknown Product',
                              price: 0,
                              quantity: 0,
                              category: '',
                            ),
                      );

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Row(
                            spacing: 10,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "ID: ${sale.productId}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${sale.date.day.toString().padLeft(2, '0')}/${sale.date.month.toString().padLeft(2, '0')}/${sale.date.year}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Qty: ${sale.quantity}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.attach_money,
                                      size: 16,
                                      color: AppColors.accent,
                                    ),
                                    Text(
                                      sale.totalPrice.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            onPressed: () {
                              final inventoryCubit =
                                  context.read<InventoryCubit>();
                              context.read<SalesCubit>().deleteSale(
                                sale,
                                inventoryCubit,
                              );
                            },
                            tooltip: 'Delete Sale',
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder:
                (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: RecordSaleForm(products: products),
                ),
          );
        },
      ),
    );
  }
}

class RecordSaleForm extends StatefulWidget {
  final List<Product> products;

  const RecordSaleForm({super.key, required this.products});

  @override
  _RecordSaleFormState createState() => _RecordSaleFormState();
}

class _RecordSaleFormState extends State<RecordSaleForm> {
  Product? selectedProduct;
  final _quantityController = TextEditingController();
  final _totalPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            "Record New Sale",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Product>(
            value: selectedProduct,
            hint: const Text('Select Product'),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            items:
                widget.products.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product.name),
                  );
                }).toList(),
            onChanged: (product) {
              setState(() {
                selectedProduct = product;
                _totalPriceController.text = '';
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (selectedProduct != null) {
                final qty = int.tryParse(_quantityController.text) ?? 0;
                _totalPriceController.text = (qty * selectedProduct!.price)
                    .toStringAsFixed(2);
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _totalPriceController,
            decoration: InputDecoration(
              labelText: 'Total Price',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              prefixIcon: const Icon(Icons.attach_money),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed:
                  selectedProduct == null
                      ? null
                      : () {
                        final id =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        final quantity =
                            int.tryParse(_quantityController.text) ?? 0;
                        final totalPrice =
                            double.tryParse(_totalPriceController.text) ?? 0.0;

                        if (quantity > 0) {
                          context.read<SalesCubit>().addSale(
                            Sale(
                              id: id,
                              productId: selectedProduct!.id,
                              quantity: quantity,
                              totalPrice: totalPrice,
                              date: DateTime.now(),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
              child: const Text('Record Sale', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
