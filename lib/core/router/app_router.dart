import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_layout.dart';
import '../../features/onboarding/presentation/pages/on_boarding_screen.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder: (context, state) => const MaterialPage(
        child: SplashScreen(),
      ),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingScreen(),
      ),
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
          pageBuilder: (context, state) => const MaterialPage(
            child: Center(child: Text("Inventory Page")),
          ),
        ),
        GoRoute(
          path: '/sales',
          name: 'sales',
          pageBuilder: (context, state) => const MaterialPage(
            child: Center(child: Text("Sales Page")),
          ),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder: (context, state) => const MaterialPage(
            child: Center(child: Text("Dashboard Page")),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => const MaterialPage(
            child: Center(child: Text("Settings Page")),
          ),
        ),
      ],
    ),
  ],
);
