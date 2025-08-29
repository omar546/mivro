import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late LiquidController _controller;
  int currentPage = 0;

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _controller = LiquidController();
    pages.addAll([
      OnboardingPage(
        isDarkText: true,
        color: const Color(0xffF5F6FA),
        image: "assets/onboardinglogodark.svg",
        title: "Organize Your Inventory",
        subtitle: "Track products, brands and stock levels in one place.",
      ),
      OnboardingPage(
        isDarkText: false,
        color: const Color(0xff3B3C9C),
        image: "assets/onboardinglogolight.svg",
        title: "Manage Sales & Receipts",
        subtitle: "Generate invoices and receipts in seconds.",
      ),
      OnboardingPage(
        isDarkText: true,
        color: const Color(0xff2FD6C9),
        image: "assets/onboardinglogodark.svg",
        title: "Your Brand at a Glance",
        subtitle: "Visual dashboards with QR contacts for quick sharing.",
      ),
    ]);
  }

  void onPageChange(int page) {
    setState(() => currentPage = page);
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final box = Hive.box('settings');
    await box.put('onboarding_done', true);

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: _controller,
            onPageChangeCallback: onPageChange,
            waveType: WaveType.liquidReveal,
            fullTransitionValue: 600,
            slideIconWidget: Icon(
              Icons.arrow_back_ios,
              color:
              currentPage == 0 || currentPage == 2
                  ? Colors.black
                  : Colors.white,
            ),
          ),

          // Indicator Dots
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 12 : 8,
                  height: currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color:
                    currentPage == index
                        ? currentPage == 0 || currentPage == 2
                        ? Colors.black
                        : Colors.white
                        : currentPage == 0 || currentPage == 2
                        ? Colors.black54
                        : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Skip / Next / Done buttons
          Positioned(
            bottom: 25,
            left: 20,
            child: TextButton(
              onPressed: () {
                _completeOnboarding(context);
                context.go('/home');
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color:
                  currentPage == 0 || currentPage == 2
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (currentPage == pages.length - 1) {
                  _completeOnboarding(context);
                  context.go('/home');
                } else {
                  _controller.animateToPage(
                    page: currentPage + 1,
                    duration: 500,
                  );
                }
              },
              child: Text(
                currentPage == pages.length - 1 ? "Done" : "Next",
                style: TextStyle(
                  color:
                  currentPage == 0 || currentPage == 2
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final Color color;
  final String image;
  final String title;
  final String subtitle;
  final bool isDarkText;

  const OnboardingPage({
    super.key,
    required this.color,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isDarkText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Fixed SVG sizing
          SizedBox(
            width: 200,
            height: 200,
            child: SvgPicture.asset(
              image,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: !isDarkText ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: !isDarkText ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}