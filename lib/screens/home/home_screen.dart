import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/components/icons/appbar_icon.dart';
import 'package:pomodoro/components/timer/pomodoro_timer.dart';
import 'package:pomodoro/utils/constants/sizes.dart';
import 'package:provider/provider.dart';
import '../history/history_screen.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnimatedBackground(),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    return AnimatedBuilder(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppBarIcon(
                    iconPath: 'assets/history.png',
                    text: 'History',
                    onPressed: () {
                      Get.to(() => const HistoryPage(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                  Text('FocusFlow',style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),),
                  AppBarIcon(
                    iconPath: 'assets/settings.png',
                    text: 'Settings',
                    onPressed: () {
                      Get.to(() => const SettingsScreen(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: PomodoroAppSizes.spaceBtwSections,
              ),
              const PomodoroTimer(),
              const SizedBox(
                height: PomodoroAppSizes.spaceBtwSections,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    margin: const EdgeInsets.only(
                        bottom: PomodoroAppSizes.spaceBtwItems),
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: PomodoroAppSizes.spaceBtwItems,
                        ),
                        Text(
                          'Donate',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
