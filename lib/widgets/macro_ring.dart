import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../theme/app_theme.dart';

class CalorieMainRing extends StatelessWidget {
  final int consumedCalories;
  final int targetCalories;
  final int burnedCalories;

  const CalorieMainRing({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    required this.burnedCalories,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (targetCalories - consumedCalories + burnedCalories);
    final percent = (consumedCalories / targetCalories).clamp(0.0, 1.0);

    return SizedBox(
      height: 210,
      width: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNeon.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                )
              ],
            ),
          ),
          // Circular Progress Bar
          CircularPercentIndicator(
            radius: 95.0,
            lineWidth: 14.0,
            animation: true,
            percent: percent,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: AppColors.darkSurfaceLight.withValues(alpha: 0.5),
            linearGradient: AppColors.primaryGradient,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.primaryCoral,
                  size: 26,
                ),
                const SizedBox(height: 2),
                Text(
                  remaining >= 0 ? '$remaining' : '0',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                ),
                Text(
                  'KCAL REMAINING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MacroProgressBar extends StatelessWidget {
  final String label;
  final double currentGrams;
  final double targetGrams;
  final Color color;
  final IconData icon;

  const MacroProgressBar({
    super.key,
    required this.label,
    required this.currentGrams,
    required this.targetGrams,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (targetGrams - currentGrams).clamp(0.0, 999.0);
    final percent = (currentGrams / (targetGrams > 0 ? targetGrams : 1.0)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Text(
              '${currentGrams.toStringAsFixed(0)} / ${targetGrams.toStringAsFixed(0)}g',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 8.0,
          percent: percent,
          padding: EdgeInsets.zero,
          barRadius: const Radius.circular(10),
          backgroundColor: color.withValues(alpha: 0.15),
          progressColor: color,
          animation: true,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${remaining.toStringAsFixed(0)}g left',
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
