import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivro/core/router/app_router.dart';
import 'package:mivro/core/colors.dart';
import 'features/inventory/data/models/category_model.dart';
import 'features/inventory/data/models/product_model_adapter.dart';
import 'features/inventory/presentation/cubit/inventory_cubit.dart';
import 'features/inventory/data/datasources/inventory_local_data_source.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/data/models/product_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  // Open a box for app settings and products
  await Hive.openBox('settings');
  final productsBox = await Hive.openBox<ProductModel>('products');
  final categoryBox = await Hive.openBox<CategoryModel>('categories');

  // Prepare repository and local data source
  final localDataSource = InventoryLocalDataSource(productsBox, categoryBox);
  final repository = InventoryRepositoryImpl(localDataSource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final InventoryRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // You can add other Cubits here later if needed
        BlocProvider(create: (_) => InventoryCubit(repository)..loadProducts()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Mivro',
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.backgroundW,
          primaryColor: AppColors.primary,
          textTheme: GoogleFonts.interTextTheme(),
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
          textTheme: GoogleFonts.interTextTheme(),
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
