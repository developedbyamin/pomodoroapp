import 'package:flutter/material.dart';
import 'package:pomodoro/utils/constants/sizes.dart';
import 'package:provider/provider.dart';
import '../../components/bar_graph/bar_graph.dart';
import '../../repository/session_repository.dart';
import '../settings/settings_controller.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({
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
    FocusSessionRepository repository = FocusSessionRepository();
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
            children: [
              const WeeklyExpenseBarGraph(),
              IconButton(
                onPressed: () async {
                  // Call getLast7DaysFocusSessions() method
                  List<String> last7DaysSessions = await repository.getLast7DaysNames();

                  // Print the results
                  for (var day in last7DaysSessions) {
                    print(day);
                  }
                },
                icon: const Icon(Icons.ac_unit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
