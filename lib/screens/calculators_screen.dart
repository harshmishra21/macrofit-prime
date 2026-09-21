import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bmi_meter.dart';
import '../widgets/glass_card.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // BMI State
  double _heightCm = 178.0;
  double _weightKg = 74.5;
  int _age = 26;
  String _gender = 'Male';

  // TDEE State
  ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;
  FitnessGoal _fitnessGoal = FitnessGoal.fatLoss;

  final double _proteinRatio = 0.30; // 30%
  final double _carbsRatio = 0.40; // 40%
  final double _fatRatio = 0.30; // 30%

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final profile = Provider.of<AppState>(context, listen: false).userProfile;
    _heightCm = profile.heightCm;
    _weightKg = profile.weightKg;
    _age = profile.age;
    _gender = profile.gender;
    _activityLevel = profile.activityLevel;
    _fitnessGoal = profile.fitnessGoal;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Calculators Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryNeon,
          labelColor: AppColors.primaryNeon,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(icon: Icon(Icons.monitor_weight_rounded), text: 'BMI Calculator'),
            Tab(icon: Icon(Icons.local_fire_department_rounded), text: 'TDEE & Calorie Goal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBmiTab(appState),
          _buildTdeeTab(appState),
        ],
      ),
    );
  }

  // TAB 1: BMI CALCULATOR
  Widget _buildBmiTab(AppState appState) {
    final bmiResult = BmiResult.calculate(_weightKg, _heightCm);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Meter
          GlassCard(
            child: BmiGaugeMeter(bmiResult: bmiResult),
          ),
          const SizedBox(height: 24),

          // Sliders & Inputs
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADJUST YOUR BIOMETRICS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.1),
                ),
                const SizedBox(height: 18),

                // Gender Toggle
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        avatar: const Icon(Icons.male_rounded, size: 20),
                        label: const Center(child: Text('Male')),
                        selected: _gender == 'Male',
                        selectedColor: AppColors.primaryCyan,
                        labelStyle: TextStyle(color: _gender == 'Male' ? Colors.black : null, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _gender = 'Male'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        avatar: const Icon(Icons.female_rounded, size: 20),
                        label: const Center(child: Text('Female')),
                        selected: _gender == 'Female',
                        selectedColor: AppColors.primaryCoral,
                        labelStyle: TextStyle(color: _gender == 'Female' ? Colors.black : null, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _gender = 'Female'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Height Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Height', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      '${_heightCm.round()} cm (${(_heightCm / 30.48).floor()}\' ${((_heightCm % 30.48) / 2.54).round()}"',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryNeon, fontSize: 16),
                    ),
                  ],
                ),
                Slider(
                  value: _heightCm,
                  min: 120,
                  max: 220,
                  activeColor: AppColors.primaryNeon,
                  onChanged: (val) => setState(() => _heightCm = val),
                ),
                const SizedBox(height: 14),

                // Weight Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Weight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      '${_weightKg.toStringAsFixed(1)} kg (${(_weightKg * 2.20462).round()} lbs)',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryCyan, fontSize: 16),
                    ),
                  ],
                ),
                Slider(
                  value: _weightKg,
                  min: 35,
                  max: 160,
                  activeColor: AppColors.primaryCyan,
                  onChanged: (val) => setState(() => _weightKg = val),
                ),
                const SizedBox(height: 14),

                // Age Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Age', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('$_age yrs', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ],
                ),
                Slider(
                  value: _age.toDouble(),
                  min: 14,
                  max: 85,
                  activeColor: AppColors.accentAmber,
                  onChanged: (val) => setState(() => _age = val.round()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Save Biometrics Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.save_rounded),
              label: const Text('SAVE TO MY PROFILE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              onPressed: () {
                appState.updateBiometrics(
                  heightCm: _heightCm,
                  weightKg: _weightKg,
                  age: _age,
                  gender: _gender,
                  activityLevel: _activityLevel,
                  fitnessGoal: _fitnessGoal,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Updated biometrics & recalculated targets!'),
                    backgroundColor: AppColors.primaryNeon,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // TAB 2: TDEE & CALORIE / MACRO CALCULATOR
  Widget _buildTdeeTab(AppState appState) {
    // Mifflin-St Jeor Formula
    double bmr;
    if (_gender == 'Male') {
      bmr = (10 * _weightKg) + (6.25 * _heightCm) - (5 * _age) + 5;
    } else {
      bmr = (10 * _weightKg) + (6.25 * _heightCm) - (5 * _age) - 161;
    }

    final tdee = bmr * _activityLevel.multiplier;
    final targetCals = (tdee + _fitnessGoal.calorieAdjustment).round();

    final calcProteinGrams = (targetCals * _proteinRatio) / 4.0;
    final calcCarbsGrams = (targetCals * _carbsRatio) / 4.0;
    final calcFatGrams = (targetCals * _fatRatio) / 9.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TDEE Overview Card
          GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(title: 'BMR', value: '${bmr.round()} kcal', subtitle: 'Basal Metabolic'),
                    Container(height: 40, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                    _StatColumn(title: 'TDEE', value: '${tdee.round()} kcal', subtitle: 'Maintenance'),
                    Container(height: 40, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                    _StatColumn(
                      title: 'GOAL',
                      value: '$targetCals kcal',
                      subtitle: _fitnessGoal.name.toUpperCase(),
                      valueColor: AppColors.primaryNeon,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Activity Level Selector
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Activity Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ...ActivityLevel.values.map((lvl) {
                  final isSelected = lvl == _activityLevel;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setState(() => _activityLevel = lvl),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryNeon.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryNeon : Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? AppColors.primaryNeon : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                lvl.title,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.primaryNeon : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Fitness Goal Selector
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fitness Objective', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: FitnessGoal.values.map((goal) {
                    final isSelected = goal == _fitnessGoal;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(goal.name.toUpperCase()),
                          selected: isSelected,
                          selectedColor: AppColors.primaryNeon,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : null,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(() => _fitnessGoal = goal),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Macro Distribution Breakdown
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Recommended Daily Macros', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(Icons.pie_chart_rounded, color: AppColors.primaryCyan),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MacroCalculatedTile(
                      name: 'Protein',
                      grams: calcProteinGrams.round(),
                      percent: (_proteinRatio * 100).round(),
                      color: AppColors.proteinColor,
                    ),
                    const SizedBox(width: 10),
                    _MacroCalculatedTile(
                      name: 'Carbs',
                      grams: calcCarbsGrams.round(),
                      percent: (_carbsRatio * 100).round(),
                      color: AppColors.carbsColor,
                    ),
                    const SizedBox(width: 10),
                    _MacroCalculatedTile(
                      name: 'Fats',
                      grams: calcFatGrams.round(),
                      percent: (_fatRatio * 100).round(),
                      color: AppColors.fatColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Apply Targets Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.bolt_rounded),
              label: const Text('APPLY THESE MACRO GOALS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              onPressed: () {
                final p = appState.userProfile;
                p.calorieTarget = targetCals;
                p.proteinTarget = calcProteinGrams;
                p.carbsTarget = calcCarbsGrams;
                p.fatTarget = calcFatGrams;
                p.activityLevel = _activityLevel;
                p.fitnessGoal = _fitnessGoal;

                appState.updateUserProfile(p);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Updated daily calorie & macro goals!'),
                    backgroundColor: AppColors.primaryNeon,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color? valueColor;

  const _StatColumn({
    required this.title,
    required this.value,
    required this.subtitle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: valueColor),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _MacroCalculatedTile extends StatelessWidget {
  final String name;
  final int grams;
  final int percent;
  final Color color;

  const _MacroCalculatedTile({
    required this.name,
    required this.grams,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Text('${grams}g', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            const SizedBox(height: 2),
            Text('$percent%', style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
