import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar Header
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryNeon.withValues(alpha: 0.3),
                          blurRadius: 16,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text('AH', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(
                          '${user.gender}, ${user.age} yrs • ${user.heightCm.round()} cm • ${user.weightKg} kg',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryNeon.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user.fitnessGoal.title,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryNeon),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Theme Customization Toggle Card
            Text('App Appearance & Theme', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: appState.isDarkMode ? Colors.amber.withValues(alpha: 0.15) : Colors.indigo.withValues(alpha: 0.15),
                        child: Icon(
                          appState.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: appState.isDarkMode ? Colors.amber : Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.isDarkMode ? 'Dark Obsidian Theme' : 'Clean Light Theme',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            appState.isDarkMode ? 'Luxury neon glows' : 'High contrast daylight palette',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: appState.isDarkMode,
                    activeTrackColor: AppColors.primaryNeon,
                    onChanged: (_) => appState.toggleTheme(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fitness Biometric Targets
            Text('Biometrics & Goals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            GlassCard(
              child: Column(
                children: [
                  _SettingRow(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Daily Calorie Target',
                    subtitle: '${user.calorieTarget} kcal',
                    color: AppColors.primaryCoral,
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.water_drop_rounded,
                    title: 'Water Hydration Goal',
                    subtitle: '${user.waterTargetMl} mL / day',
                    color: AppColors.waterColor,
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.scale_rounded,
                    title: 'Target Body Weight',
                    subtitle: '${user.targetWeightKg} kg',
                    color: AppColors.primaryCyan,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reset Data Action
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('RESET WATER & TODAY MEALS', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  appState.resetWater();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Water & Today logs reset.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ],
    );
  }
}
