import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mivro/core/router/app_router.dart';

import 'core/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  await Hive.initFlutter();

  // Open a box for app settings
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mivro',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundW,
        primaryColor: AppColors.primary,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: AppColors.primarySwatch,
        scaffoldBackgroundColor: AppColors.backgroundB,
        primaryColor: AppColors.primary,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
