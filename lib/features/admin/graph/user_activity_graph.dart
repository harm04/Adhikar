import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UsersDailyActivityGraph extends StatelessWidget {
  final int users;
  final int posts;
  final int showcases;

  const UsersDailyActivityGraph({
    super.key,
    required this.users,
    required this.posts,
    required this.showcases,
  });

  @override
  Widget build(BuildContext context) {
    final barColors = [Colors.blue, Colors.green, Colors.purple];
    final barLabels = ['Users', 'Posts', 'Showcases'];
    final barValues = [users, posts, showcases];

    return SizedBox(
      height: 180,
      width: 800, // Increased width value
      child: BarChart(
        BarChartData(
          barGroups: List.generate(3, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: barValues[i].toDouble(),
                  color: barColors[i],
                  width: 30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < barLabels.length) {
                    return Text(barLabels[value.toInt()]);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          groupsSpace: 16,
        ),
      ),
    );
  }
}
