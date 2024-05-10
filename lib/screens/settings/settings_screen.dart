import 'package:flutter/material.dart';
import 'package:pomodoro/screens/settings/settings_controller.dart';
import 'package:pomodoro/screens/settings/theme_section/theme_section.dart';
import 'package:pomodoro/utils/constants/sizes.dart';
import 'package:provider/provider.dart';
import 'keep_screen_on.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: AnimatedBackground(),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Decoration> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Adjust duration as needed
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Settings', style: textTheme.titleLarge!.copyWith(color: Colors.white),),
                const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const KeepScreenOnSwitch(),
                    const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                    const ThemeSection(),
                    const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.privacy_tip, color: Colors.white,),
                                  const SizedBox(width: PomodoroAppSizes.spaceBtwItems,),
                                  Text('Privacy & Policy',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star_rate, color: Colors.white,),
                                  const SizedBox(width: PomodoroAppSizes.spaceBtwItems,),
                                  Text('Rate us',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.edit_document, color: Colors.white,),
                                  const SizedBox(width: PomodoroAppSizes.spaceBtwItems,),
                                  Text('Terms & Conditions',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.message, color: Colors.white,),
                                  const SizedBox(width: PomodoroAppSizes.spaceBtwItems,),
                                  Text('Feedback & Support',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                Text('Version 1.1.2',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
