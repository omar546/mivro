import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/colors.dart';
import '../../inventory/presentation/cubit/inventory_cubit.dart';
import '../../sales/presentation/cubit/sales_cubit.dart';
import 'dart:collection';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime? startDate;
  DateTime? endDate;

  void _clearFilters() {
    setState(() {
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Analytics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDateFilter(),
            const SizedBox(height: 16),
            Expanded(child: _buildCharts()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
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
              const SizedBox(width: 10),
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
    );
  }

  Widget _buildCharts() {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, salesState) {
        if (salesState is SalesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (salesState is SalesLoaded) {
          return BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, inventoryState) {
              return _buildAnalyticsContent(salesState, inventoryState);
            },
          );
        }
        return const Center(child: Text('Failed to load sales data'));
      },
    );
  }

  Widget _buildAnalyticsContent(
    SalesLoaded salesState,
    InventoryState inventoryState,
  ) {
    // Filter sales by selected date range
    final filteredSales =
        salesState.sales.where((sale) {
          if (startDate != null && sale.date.isBefore(startDate!)) return false;
          if (endDate != null &&
              sale.date.isAfter(endDate!.add(const Duration(days: 1)))) {
            return false;
          }
          return true;
        }).toList();

    // Product mapping
    final productMap = {for (var p in inventoryState.products) p.id: p};

    // Calculate metrics
    final metrics = _calculateMetrics(filteredSales, inventoryState.products);
    final salesByDate = _getSalesByDate(filteredSales);
    final productSales = _getProductSales(filteredSales, productMap);
    final categorySales = _getCategorySales(filteredSales, productMap);
    final lowStockProducts = _getLowStockProducts(inventoryState.products);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Cards
          _buildMetricsCards(metrics),
          const SizedBox(height: 24),

          // Sales Over Time Chart
          _buildSectionTitle("Sales Trends"),
          _buildSalesLineChart(salesByDate),
          const SizedBox(height: 24),

          // Product Performance Charts
          _buildSectionTitle("Product Performance"),
          _buildProductBarChart(productSales),
          const SizedBox(height: 24),

          // Category Performance
          _buildSectionTitle("Category Performance"),
          _buildCategoryPieChart(categorySales),
          const SizedBox(height: 24),

          // Inventory Status
          _buildSectionTitle("Inventory Status"),
          _buildInventoryStatus(inventoryState.products, lowStockProducts),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateMetrics(
    List<dynamic> sales,
    List<dynamic> products,
  ) {
    final totalSales = sales.length;
    final totalRevenue = sales.fold<double>(
      0,
      (sum, sale) => sum + sale.totalPrice,
    );
    final totalUnits = sales.fold<int>(
      0,
      (sum, sale) => (sum + sale.quantity) as int,
    );
    final avgSaleValue = totalSales > 0 ? totalRevenue / totalSales : 0.0;

    return {
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'totalUnits': totalUnits,
      'avgSaleValue': avgSaleValue,
    };
  }

  SplayTreeMap<DateTime, double> _getSalesByDate(List<dynamic> sales) {
    final salesByDate = SplayTreeMap<DateTime, double>();
    for (var sale in sales) {
      final day = DateTime(sale.date.year, sale.date.month, sale.date.day);
      salesByDate[day] = (salesByDate[day] ?? 0) + sale.totalPrice;
    }
    return salesByDate;
  }

  Map<String, Map<String, dynamic>> _getProductSales(
    List<dynamic> sales,
    Map<String, dynamic> productMap,
  ) {
    final productSales = <String, Map<String, dynamic>>{};
    for (var sale in sales) {
      final productId = sale.productId;
      final product = productMap[productId];
      if (product != null) {
        final productName = product.name;
        if (!productSales.containsKey(productName)) {
          productSales[productName] = {'quantity': 0, 'revenue': 0.0};
        }
        productSales[productName]!['quantity'] += sale.quantity;
        productSales[productName]!['revenue'] += sale.totalPrice;
      }
    }
    return productSales;
  }

  Map<String, Map<String, dynamic>> _getCategorySales(
    List<dynamic> sales,
    Map<String, dynamic> productMap,
  ) {
    final categorySales = <String, Map<String, dynamic>>{};
    for (var sale in sales) {
      final product = productMap[sale.productId];
      if (product != null) {
        final category = product.category ?? 'Uncategorized';
        if (!categorySales.containsKey(category)) {
          categorySales[category] = {'quantity': 0, 'revenue': 0.0};
        }
        categorySales[category]!['quantity'] += sale.quantity;
        categorySales[category]!['revenue'] += sale.totalPrice;
      }
    }
    return categorySales;
  }

  List<dynamic> _getLowStockProducts(List<dynamic> products) {
    return products.where((product) => product.quantity <= 10).toList();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMetricsCards(Map<String, dynamic> metrics) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          "Total Sales",
          metrics['totalSales'].toString(),
          Icons.receipt_long,
          Colors.blue,
        ),
        _buildMetricCard(
          "Revenue",
          "\$${metrics['totalRevenue'].toStringAsFixed(2)}",
          Icons.attach_money,
          Colors.green,
        ),
        _buildMetricCard(
          "Units Sold",
          metrics['totalUnits'].toString(),
          Icons.inventory,
          Colors.orange,
        ),
        _buildMetricCard(
          "Avg Sale Value",
          "\$${metrics['avgSaleValue'].toStringAsFixed(2)}",
          Icons.trending_up,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesLineChart(SplayTreeMap<DateTime, double> salesByDate) {
    if (salesByDate.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No sales data available')),
      );
    }

    final spots =
        salesByDate.entries.map((entry) {
          final daysSinceEpoch =
              entry.key.difference(DateTime(2020, 1, 1)).inDays;
          return FlSpot(daysSinceEpoch.toDouble(), entry.value);
        }).toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final date = DateTime(
                    2020,
                    1,
                    1,
                  ).add(Duration(days: value.toInt()));
                  return Text(
                    '${date.day}/${date.month}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.accent,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accent.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductBarChart(Map<String, Map<String, dynamic>> productSales) {
    if (productSales.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('No product sales data available')),
      );
    }

    // Sort products by quantity sold and take top 10
    final sortedProducts =
        productSales.entries.toList()
          ..sort((a, b) => b.value['quantity'].compareTo(a.value['quantity']));
    final topProducts = sortedProducts.take(10).toList();

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= topProducts.length) return const Text('');
                  final productName = topProducts[index].key;
                  return RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      productName.length > 10
                          ? '${productName.substring(0, 10)}...'
                          : productName,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: List.generate(topProducts.length, (index) {
            final qty = topProducts[index].value['quantity'];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: qty.toDouble(),
                  color: AppColors.accent,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(
    Map<String, Map<String, dynamic>> categorySales,
  ) {
    if (categorySales.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No category sales data available')),
      );
    }

    final colors = [
      AppColors.primary,
      AppColors.accent,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    final sections =
        categorySales.entries.map((entry) {
          final index = categorySales.keys.toList().indexOf(entry.key);
          final revenue = entry.value['revenue'].toDouble();
          final totalRevenue = categorySales.values.fold<double>(
            0,
            (sum, cat) => sum + cat['revenue'],
          );
          final percentage =
              totalRevenue > 0 ? (revenue / totalRevenue) * 100 : 0.0;

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: revenue,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                categorySales.entries.map((entry) {
                  final index = categorySales.keys.toList().indexOf(entry.key);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryStatus(
    List<dynamic> products,
    List<dynamic> lowStockProducts,
  ) {
    final totalProducts = products.length;
    final inStockProducts = products.where((p) => p.quantity > 0).length;
    final outOfStockProducts = products.where((p) => p.quantity == 0).length;

    return Column(
      children: [
        // Inventory Overview Cards
        Row(
          children: [
            Expanded(
              child: _buildInventoryCard(
                "Total Products",
                totalProducts.toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInventoryCard(
                "In Stock",
                inStockProducts.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInventoryCard(
                "Out of Stock",
                outOfStockProducts.toString(),
                Icons.warning,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Low Stock Alert
        if (lowStockProducts.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      "Low Stock Alert (≤10 units)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...lowStockProducts
                    .take(5)
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "• ${product.name}: ${product.quantity} units left",
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ),
                if (lowStockProducts.length > 5)
                  Text(
                    "... and ${lowStockProducts.length - 5} more",
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInventoryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SalesLineChart extends StatelessWidget {
  final SplayTreeMap<DateTime, double> salesData;

  const _SalesLineChart({required this.salesData});

  @override
  Widget build(BuildContext context) {
    if (salesData.isEmpty) {
      return const Center(child: Text("No sales data available"));
    }

    final spots =
        salesData.entries.map((entry) {
          final daysSinceEpoch =
              entry.key.difference(DateTime(2020, 1, 1)).inDays;
          return FlSpot(daysSinceEpoch.toDouble(), entry.value);
        }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final date = DateTime(
                  2020,
                  1,
                  1,
                ).add(Duration(days: value.toInt()));
                return Text(
                  '${date.day}/${date.month}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.accent,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.accent.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
