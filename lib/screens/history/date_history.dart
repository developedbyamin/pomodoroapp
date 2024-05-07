import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pomodoro/utils/constants/sizes.dart';

import '../../models/session_repository.dart';

class WeeklyExpenseBarGraph2 extends StatelessWidget {
  final List<double> expenses;

  const WeeklyExpenseBarGraph2({super.key, required this.expenses,});



  @override
  Widget build(BuildContext context) {
    final FocusSessionRepository repository = FocusSessionRepository();
    final List<String> daysOfWeek = repository.getLast7DaysFocusSessions() as List<String>;
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) {
                return Colors.white;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()}',
                  const TextStyle(color: Colors.black), // Change text color of the tooltip text
                );
              },
              // Change background color of the tooltip container
            ),
          ),
          backgroundColor: Colors.transparent,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false,),),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    daysOfWeek[value.toInt()],
                    style: const TextStyle(
                      color: Colors.white, // Change text color here
                    ),
                  );
                },
              ),
              axisNameWidget: const Text('Weekly Statistics', style: TextStyle(color: Colors.white, fontSize: 18),),
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
              bottom: BorderSide(color: Colors.white, width: 1),
              left: BorderSide(color: Colors.white, width: 1),
            ),
          ),
          barGroups: _getBarGroups(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(expenses.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: expenses[index], color: Colors.white)],
      );
    });
  }
}
