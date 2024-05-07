import 'package:flutter/material.dart';
import 'package:pomodoro/models/session_record_model.dart';
import 'package:pomodoro/models/session_repository.dart';
import 'package:pomodoro/screens/statistics/bar_graph/bar_graph.dart';
import 'package:pomodoro/utils/constants/sizes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package

import '../settings/settings_controller.dart';

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

  final FocusSessionRepository repository = FocusSessionRepository();
  late List<FocusSessionRecord> sessionRecords = [];
  late Map<DateTime, int> dailyFocusedTime = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSessionRecords();
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

  Future<void> loadSessionRecords() async {
    setState(() {
      _isLoading = true; // Set isLoading to true when loading starts
    });
    List<FocusSessionRecord> records = await repository.getAllFocusSessions();
    Map<DateTime, int> focusedTime =
        await repository.calculateDailyFocusedTime();
    setState(() {
      sessionRecords = records;
      dailyFocusedTime = focusedTime;
      _isLoading = false; // Set isLoading to false after loading completes
    });
  }

  String formatFocusedTime(int totalFocusedTime) {
    int hours = totalFocusedTime ~/ 3600;
    int minutes = (totalFocusedTime % 3600) ~/ 60;
    int seconds = totalFocusedTime % 60;

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours hours ';
    }
    if (minutes > 0) {
      formattedTime += '$minutes minutes ';
    }
    if (seconds > 0) {
      formattedTime += '$seconds seconds';
    }
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
          child: Stack(
            children: [
              child!,
              Positioned(
                bottom: PomodoroAppSizes.spaceBtwItems,
                right: PomodoroAppSizes.spaceBtwItems,
                child: _buildButton(),
              ),
            ],
          ),
        );
      },
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
              WeeklyExpenseBarGraph(
                focusedTime: const [100, 150, 200, 175, 120, 90, 10],
                daysOfWeek: daysOfWeek,
              ),
              const SizedBox(
                height: PomodoroAppSizes.spaceBtwItems,
              ),
              Expanded(
                child:
                    _isLoading // Show circular progress indicator if isLoading is true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : sessionRecords.isNotEmpty // Show records if available
                            ? ListView.builder(
                                shrinkWrap: false,
                                itemCount: dailyFocusedTime.length,
                                itemBuilder: (context, index) {
                                  DateTime currentDate =
                                      dailyFocusedTime.keys.toList()[index];
                                  int totalFocusedTime =
                                      dailyFocusedTime[currentDate]!;
                                  String formattedDate = DateFormat.MMMMd()
                                      .format(
                                          currentDate); // Format date as "May 6"
                                  return Container(
                                    padding: const EdgeInsets.all(
                                        PomodoroAppSizes.spaceBtwItems),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                    margin: const EdgeInsets.only(
                                        bottom: PomodoroAppSizes.spaceBtwItems),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Focused time: ${formatFocusedTime(totalFocusedTime)}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No records found.",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: () async {
          // Delete all records
          await FocusSessionRepository().deleteAllFocusSessions();
          await loadSessionRecords();
        },
        icon: const Icon(Icons.delete_outline, size: 32, color: Colors.white),
      ),
    );
  }
}
