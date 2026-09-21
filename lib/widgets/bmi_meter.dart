import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class BmiGaugeMeter extends StatelessWidget {
  final BmiResult bmiResult;

  const BmiGaugeMeter({super.key, required this.bmiResult});

  @override
  Widget build(BuildContext context) {
    // Scale BMI from 15.0 to 35.0 into 0.0 -> 1.0 fraction position
    final clampedBmi = bmiResult.bmi.clamp(15.0, 35.0);
    final indicatorPosition = (clampedBmi - 15.0) / (35.0 - 15.0);

    return Column(
      children: [
        // BMI Big Counter Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: bmiResult.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: bmiResult.color.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                bmiResult.bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: bmiResult.color,
                  letterSpacing: -1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: bmiResult.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bmiResult.category.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Visual Segment Bar & Indicator
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            final markerX = (indicatorPosition * barWidth).clamp(12.0, barWidth - 12.0);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Multi-colored Gradient Segment Bar
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.bmiUnderweight,
                        AppColors.bmiNormal,
                        AppColors.bmiOverweight,
                        AppColors.bmiObese,
                      ],
                      stops: [0.0, 0.35, 0.70, 1.0],
                    ),
                  ),
                ),

                // Indicator Needle Marker
                Positioned(
                  left: markerX - 10,
                  top: -6,
                  child: Container(
                    height: 28,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: bmiResult.color, width: 3.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 14),
        // Scale labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('15.0', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('18.5', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('24.9', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('29.9', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('35.0+', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),

        const SizedBox(height: 20),

        // Advice Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurfaceLight
                : AppColors.lightSurfaceSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: bmiResult.color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ideal Weight: ${bmiResult.idealWeightRange}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bmiResult.message,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
