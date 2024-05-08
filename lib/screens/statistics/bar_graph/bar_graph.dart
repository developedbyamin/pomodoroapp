import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:pomodoro/utils/constants/sizes.dart';
import '../../../repository/session_repository.dart';

class WeeklyExpenseBarGraph extends StatefulWidget {
  const WeeklyExpenseBarGraph({
    super.key,
  });

  @override
  State<WeeklyExpenseBarGraph> createState() => _WeeklyExpenseBarGraphState();
}

class _WeeklyExpenseBarGraphState extends State<WeeklyExpenseBarGraph> {
  List<double> focusedTime = [];
  FocusSessionRepository repository = FocusSessionRepository();
  List<String> daysOfWeek = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<String> last7Days = await repository.getLast7DaysNames();
    Map<DateTime, int> dailyFocused = await repository.calculateDailyFocusedTime();

    print('Keys in dailyFocused map:');
    for (var key in dailyFocused.keys) {
      print(key);
    }

    List<double> focusedHours = _calculateFocusedHours(last7Days, dailyFocused);
    setState(() {
      daysOfWeek = last7Days;
      focusedTime = focusedHours;
    });
  }

  List<double> _calculateFocusedHours(List<String> days, Map<DateTime, int> dailyFocused) {
    return days.map((day) {
      DateTime dateTime = DateTime.now();
      switch (day) {
        case 'Mon':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));
          break;
        case 'Tue':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 2));
          break;
        case 'Wed':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 3));
          break;
        case 'Thu':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 4));
          break;
        case 'Fri':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 5));
          break;
        case 'Sat':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 6));
          break;
        case 'Sun':
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday));
          break;
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      print('Day of week: $day, Calculated DateTime: $formattedDate');
      int focusedSeconds = dailyFocused[DateTime.parse(formattedDate)] ?? 0;
      print('Focused seconds for $formattedDate: $focusedSeconds');
      return focusedSeconds / 3600; // Convert seconds to hours
    }).toList();
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(focusedTime.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: focusedTime[index], color: Colors.white)
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
      child: BarChart(
        BarChartData(
          maxY: 24,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) {
                return Colors.white;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()}',
                  const TextStyle(
                      color: Colors
                          .black), // Change text color of the tooltip text
                );
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < daysOfWeek.length) {
                    return Text(
                      index == daysOfWeek.length - 1 ? 'Today' : daysOfWeek[index],
                      style: const TextStyle(
                        color: Colors.white, // Change text color here
                      ),
                    ); // Access daysOfWeek safely
                  }
                  return const Text('');
                },
              ),
              axisNameWidget: const Text(
                'Weekly Statistics (hourly)',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              axisNameSize: 24,
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.white, width: 3),
              left: BorderSide(color: Colors.white, width: 3),
            ),
          ),
          barGroups: _getBarGroups(),
        ),
      ),
    );
  }
}
