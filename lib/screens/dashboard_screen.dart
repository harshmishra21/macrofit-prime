import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/macro_ring.dart';
import '../widgets/quick_add_modal.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.userProfile;

    final consumedCals = appState.todayConsumedCalories;
    final targetCals = user.calorieTarget;
    final burnedCals = appState.todayBurnedCalories;

    final consumedProtein = appState.todayConsumedProtein;
    final consumedCarbs = appState.todayConsumedCarbs;
    final consumedFat = appState.todayConsumedFat;

    final waterMl = appState.waterIntakeMl;
    final waterTarget = user.waterTargetMl;
    final waterPercent = (waterMl / waterTarget).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hey, ${user.name}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(width: 6),
                          const Text('🔥', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                      Text(
                        'Target: ${user.fitnessGoal.title}',
                        style: const TextStyle(
                          color: AppColors.primaryNeon,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  // Theme Toggle Button
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: appState.isDarkMode
                          ? AppColors.darkSurfaceLight
                          : AppColors.lightSurfaceSecondary,
                    ),
                    icon: Icon(
                      appState.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: appState.isDarkMode ? Colors.amber : Colors.indigo,
                    ),
                    onPressed: () => appState.toggleTheme(),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              // Main Calorie Ring & Macro Card
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'DAILY ENERGY OVERVIEW',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryNeon.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$consumedCals / $targetCals KCAL',
                            style: const TextStyle(
                              color: AppColors.primaryNeon,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ring
                    CalorieMainRing(
                      consumedCalories: consumedCals,
                      targetCalories: targetCals,
                      burnedCalories: burnedCals,
                    ),
                    const SizedBox(height: 24),

                    // Macro Progress Bars
                    MacroProgressBar(
                      label: 'PROTEIN',
                      currentGrams: consumedProtein,
                      targetGrams: user.proteinTarget,
                      color: AppColors.proteinColor,
                      icon: Icons.fitness_center_rounded,
                    ),
                    const SizedBox(height: 12),
                    MacroProgressBar(
                      label: 'CARBS',
                      currentGrams: consumedCarbs,
                      targetGrams: user.carbsTarget,
                      color: AppColors.carbsColor,
                      icon: Icons.grain_rounded,
                    ),
                    const SizedBox(height: 12),
                    MacroProgressBar(
                      label: 'FATS',
                      currentGrams: consumedFat,
                      targetGrams: user.fatTarget,
                      color: AppColors.fatColor,
                      icon: Icons.water_drop_rounded,
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.1, duration: 400.ms),

              const SizedBox(height: 20),

              // Hydration Tracker Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.water_drop_rounded, color: AppColors.waterColor, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Water Hydration Tracker',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          '$waterMl / $waterTarget mL',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.waterColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Animated Progress fill
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: waterPercent,
                        minHeight: 12,
                        backgroundColor: AppColors.waterColor.withValues(alpha: 0.15),
                        color: AppColors.waterColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.waterColor,
                            side: const BorderSide(color: AppColors.waterColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('+250 mL', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => appState.addWater(250),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.waterColor,
                            side: const BorderSide(color: AppColors.waterColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('+500 mL', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => appState.addWater(500),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.grey),
                          onPressed: () => appState.resetWater(),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 20),

              // Quick Meal Log Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Meal Logging",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () => onNavigateTab(1), // Go to Meals tab
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: MealCategory.values.map((cat) {
                    final mealsForCat = appState.todayLoggedMeals.where((m) => m.category == cat);
                    final catCals = mealsForCat.fold(0, (sum, m) => sum + m.totalCalories);

                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 18,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => QuickAddModal(defaultCategory: cat),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primaryNeon.withValues(alpha: 0.15),
                                  child: Icon(cat.icon, size: 18, color: AppColors.primaryNeon),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  cat.displayName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '$catCals kcal',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${mealsForCat.length} items logged',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Active Workout / Burned Summary Card
              GlassCard(
                customBgColor: appState.isDarkMode
                    ? AppColors.darkSurfaceLight
                    : AppColors.lightSurfaceSecondary,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.fireGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Fitness Burn',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$burnedCals kcal burned today',
                            style: const TextStyle(color: AppColors.primaryCoral, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNeon,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => onNavigateTab(3), // Navigate to Workouts tab
                      child: const Text('Workouts', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
