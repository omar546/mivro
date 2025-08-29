import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _scaleController.forward();
    _rotationController.repeat();
    _checkOnboarding();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _checkOnboarding() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final box = Hive.box('settings');
    final done = box.get('onboarding_done', defaultValue: false);

    if (!mounted) return; // ✅ prevent calling context if widget disposed

    if (done) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final logoAsset =
        brightness == Brightness.dark
            ? 'assets/logo_light.svg'
            : 'assets/logo_dark.svg';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                brightness == Brightness.dark
                    ? [const Color(0xFF1a1a1a), const Color(0xFF2d2d2d)]
                    : [const Color(0xFFf8f9fa), const Color(0xFFe9ecef)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: SvgPicture.asset(logoAsset, width: 120, height: 120),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
