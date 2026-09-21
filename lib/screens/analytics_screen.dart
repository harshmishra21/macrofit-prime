import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.userProfile;

    final todayProtein = appState.todayConsumedProtein;
    final todayCarbs = appState.todayConsumedCarbs;
    final todayFat = appState.todayConsumedFat;

    final totalGrams = (todayProtein + todayCarbs + todayFat);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Progress Insights', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Card
            GlassCard(
              customBgColor: appState.isDarkMode ? AppColors.darkSurfaceLight : AppColors.lightSurfaceSecondary,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.black, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('7 DAY FITNESS STREAK!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      SizedBox(height: 2),
                      Text('Target Macro Adherence: 94%', style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Weekly Calorie Bar Chart
            Text('Weekly Calorie Adherence (Kcal)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            GlassCard(
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 2800,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (val.toInt() >= 0 && val.toInt() < days.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(days[val.toInt()], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _makeBarGroup(0, 2100, targetKcal: user.calorieTarget),
                      _makeBarGroup(1, 2350, targetKcal: user.calorieTarget),
                      _makeBarGroup(2, 2200, targetKcal: user.calorieTarget),
                      _makeBarGroup(3, 2400, targetKcal: user.calorieTarget),
                      _makeBarGroup(4, 2150, targetKcal: user.calorieTarget),
                      _makeBarGroup(5, 1980, targetKcal: user.calorieTarget),
                      _makeBarGroup(6, appState.todayConsumedCalories.toDouble(), targetKcal: user.calorieTarget, isToday: true),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Macro Distribution Pie Chart
            Text("Today's Macro Breakdown", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            GlassCard(
              child: SizedBox(
                height: 180,
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                              color: AppColors.proteinColor,
                              value: todayProtein > 0 ? todayProtein : 30,
                              title: '${totalGrams > 0 ? ((todayProtein / totalGrams) * 100).round() : 30}%',
                              radius: 35,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                            ),
                            PieChartSectionData(
                              color: AppColors.carbsColor,
                              value: todayCarbs > 0 ? todayCarbs : 40,
                              title: '${totalGrams > 0 ? ((todayCarbs / totalGrams) * 100).round() : 40}%',
                              radius: 35,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                            ),
                            PieChartSectionData(
                              color: AppColors.fatColor,
                              value: todayFat > 0 ? todayFat : 30,
                              title: '${totalGrams > 0 ? ((todayFat / totalGrams) * 100).round() : 30}%',
                              radius: 35,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendRow(label: 'Protein: ${todayProtein.toStringAsFixed(0)}g', color: AppColors.proteinColor),
                        const SizedBox(height: 8),
                        _LegendRow(label: 'Carbs: ${todayCarbs.toStringAsFixed(0)}g', color: AppColors.carbsColor),
                        const SizedBox(height: 8),
                        _LegendRow(label: 'Fat: ${todayFat.toStringAsFixed(0)}g', color: AppColors.fatColor),
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Weight Trend Line Chart
            Text('Weight Trajectory (kg)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            GlassCard(
              child: SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1.0,
                          getTitlesWidget: (val, meta) => Text('${val.toInt()}k', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (val.toInt() >= 0 && val.toInt() < days.length) {
                              return Text(days[val.toInt()], style: const TextStyle(fontSize: 10, color: Colors.grey));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: 73.0,
                    maxY: 78.0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 76.5),
                          FlSpot(1, 76.2),
                          FlSpot(2, 75.8),
                          FlSpot(3, 75.5),
                          FlSpot(4, 75.2),
                          FlSpot(5, 75.1),
                          FlSpot(6, 75.0),
                        ],
                        isCurved: true,
                        color: AppColors.primaryNeon,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primaryNeon.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, {required int targetKcal, bool isToday = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isToday ? AppColors.primaryNeon : AppColors.primaryCyan.withValues(alpha: 0.7),
          width: 18,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendRow({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
