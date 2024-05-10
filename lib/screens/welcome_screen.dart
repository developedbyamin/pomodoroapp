import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/screens/home/home_screen.dart';
import 'package:pomodoro/screens/settings/settings_controller.dart';
import 'package:pomodoro/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnimatedBackground(),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key,});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Decoration> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _navigateToHomeScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAll(() => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    _animation = DecorationTween(
      begin: BoxDecoration(
        gradient: LinearGradient(
          colors: settingsController.selectedGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      end: BoxDecoration(
        gradient: LinearGradient(
          colors: settingsController.selectedGradient.reversed.toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ).animate(_controller);

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return DecoratedBox(
              decoration: _animation.value,
              child: child,
            );
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'FocusFlow',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: PomodoroAppSizes.spaceBtwSections,),
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white,strokeWidth: 5,strokeAlign: 1, ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Loading indicator
      ],
    );
  }
}
