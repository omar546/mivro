import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivro/core/router/app_router.dart';
import 'package:mivro/core/colors.dart';

// Inventory imports
import 'features/inventory/data/models/category_model.dart';
import 'features/inventory/data/models/product_model_adapter.dart';
import 'features/inventory/presentation/cubit/inventory_cubit.dart';
import 'features/inventory/data/datasources/inventory_local_data_source.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/data/models/product_model.dart';

// Sales imports
import 'features/sales/data/data source/sales_local_data_source.dart';
import 'features/sales/data/models/sale_model.dart';
import 'features/sales/data/models/sales_model_adapter.dart';
import 'features/sales/data/repositories/sales_repository_impl.dart';
import 'features/sales/presentation/cubit/sales_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(SaleModelAdapter());

  // Open boxes
  await Hive.openBox('settings');
  final productsBox = await Hive.openBox<ProductModel>('products');
  final categoryBox = await Hive.openBox<CategoryModel>('categories');
  final salesBox = await Hive.openBox<SaleModel>('sales');

  // Prepare repositories
  final inventoryRepo = InventoryRepositoryImpl(
    InventoryLocalDataSource(productsBox, categoryBox),
  );
  final salesRepo = SalesRepositoryImpl(
    SalesLocalDataSource(salesBox),
    inventoryRepo,
  );

  // Create InventoryCubit separately
  final inventoryCubit = InventoryCubit(inventoryRepo)..loadProducts();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<InventoryCubit>.value(value: inventoryCubit),
        BlocProvider<SalesCubit>(
          create: (_) => SalesCubit(salesRepo, inventoryCubit)..loadSales(),
        ),
      ],
      child: MyApp(
        inventoryRepository: inventoryRepo,
        salesRepository: salesRepo,
        inventoryCubit: inventoryCubit,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final InventoryRepositoryImpl inventoryRepository;
  final SalesRepositoryImpl salesRepository;
  final InventoryCubit inventoryCubit;

  const MyApp({
    super.key,
    required this.inventoryRepository,
    required this.salesRepository,
    required this.inventoryCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InventoryCubit(inventoryRepository)..loadProducts(),
        ),
        BlocProvider(
          create:
              (_) => SalesCubit(salesRepository, inventoryCubit)..loadSales(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Mivro',
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.backgroundW,
          primaryColor: AppColors.primary,
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            splashColor: AppColors.warning,
            backgroundColor: AppColors.error,
            shape: CircleBorder(),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: AppColors.primarySwatch,
          scaffoldBackgroundColor: AppColors.backgroundB,
          primaryColor: AppColors.primary,
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            splashColor: AppColors.warning,
            backgroundColor: AppColors.error,
            shape: CircleBorder(),
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
