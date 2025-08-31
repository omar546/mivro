import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_layout.dart';
import '../../features/inventory/presentation/pages/inventory_screen.dart';
import '../../features/onboarding/presentation/pages/on_boarding_screen.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/brand/presentation/pages/brand_screen.dart';
import '../../features/sales/presentation/pages/sales_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder:
          (context, state) => const MaterialPage(child: SplashScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder:
          (context, state) => const MaterialPage(child: OnboardingScreen()),
    ),

    /// ShellRoute wraps HomeLayout
    ShellRoute(
      builder: (context, state, child) {
        return HomeLayout(child: child); // <== pass the active child
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder:
              (context, state) => const MaterialPage(child: InventoryScreen()),
        ),
        GoRoute(
          path: '/sales',
          name: 'sales',
          pageBuilder:
              (context, state) => const MaterialPage(child: SalesScreen()),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder:
              (context, state) => const MaterialPage(
                child: Center(child: Text("Dashboard Page")),
              ),
        ),
        GoRoute(
          path: '/brand',
          name: 'brand',
          pageBuilder:
              (context, state) => const MaterialPage(child: BrandInfoScreen()),
        ),
      ],
    ),
  ],
);
