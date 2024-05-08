import 'package:flutter/material.dart';
import 'package:pomodoro/screens/statistics/bar_graph/bar_graph.dart';
import 'package:pomodoro/utils/constants/sizes.dart';
import 'package:provider/provider.dart';
import '../settings/settings_controller.dart';
import 'date_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: AnimatedBackground(),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Decoration> _animation;
  HistoryList historyList = const HistoryList();

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
    final textTheme = Theme.of(context).textTheme;
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
          child: Padding(
            padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('History',
                      style: textTheme.titleLarge!.copyWith(color: Colors.white)),
                  const SizedBox(
                    height: PomodoroAppSizes.spaceBtwItems,
                  ),
                  const WeeklyExpenseBarGraph(),
                  const SizedBox(
                    height: PomodoroAppSizes.spaceBtwSections,
                  ),
                  const HistoryList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
