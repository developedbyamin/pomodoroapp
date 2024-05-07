import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pomodoro/utils/constants/sizes.dart';

class WeeklyExpenseBarGraph extends StatelessWidget {
  final List<double> focusedTime;
  final List<String> daysOfWeek;

  const WeeklyExpenseBarGraph({super.key, required this.focusedTime, required this.daysOfWeek});

  @override
  Widget build(BuildContext context) {
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
    return List.generate(focusedTime.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: focusedTime[index], color: Colors.white)],
      );
    });
  }
}
