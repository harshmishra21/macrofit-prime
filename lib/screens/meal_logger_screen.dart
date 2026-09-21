import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/quick_add_modal.dart';

class MealLoggerScreen extends StatefulWidget {
  const MealLoggerScreen({super.key});

  @override
  State<MealLoggerScreen> createState() => _MealLoggerScreenState();
}

class _MealLoggerScreenState extends State<MealLoggerScreen> {
  String _searchQuery = '';
  MealCategory? _selectedCategoryFilter;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final allFoods = appState.allFoods;
    final loggedMeals = appState.todayLoggedMeals;

    final filteredFoods = allFoods.where((food) {
      final matchesSearch = food.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategoryFilter == null || food.defaultCategory == _selectedCategoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals & Nutrition Log', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryNeon, size: 28),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const QuickAddModal(defaultCategory: MealCategory.lunch),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search food database...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: appState.isDarkMode ? AppColors.darkSurface : AppColors.lightSurfaceSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Foods'),
                    selected: _selectedCategoryFilter == null,
                    selectedColor: AppColors.primaryNeon,
                    labelStyle: TextStyle(
                      color: _selectedCategoryFilter == null ? Colors.black : null,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => setState(() => _selectedCategoryFilter = null),
                  ),
                  const SizedBox(width: 8),
                  ...MealCategory.values.map((cat) {
                    final isSelected = _selectedCategoryFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.black : AppColors.primaryNeon),
                        label: Text(cat.displayName),
                        selected: isSelected,
                        selectedColor: AppColors.primaryNeon,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : null,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) => setState(() => _selectedCategoryFilter = val ? cat : null),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Logged Items Section
            Text(
              "Today's Logged Meals (${loggedMeals.length})",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            if (loggedMeals.isEmpty)
              GlassCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.restaurant_menu_rounded, size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('No meals logged yet today.', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + on any food below or quick add to log your macros!',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Column(
                children: loggedMeals.map((meal) {
                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    borderRadius: 16,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            meal.foodItem.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 60,
                              height: 60,
                              color: AppColors.primaryNeon.withValues(alpha: 0.2),
                              child: const Icon(Icons.fastfood, color: AppColors.primaryNeon),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    meal.category.displayName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNeon,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '• ${meal.foodItem.servingSize}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                meal.foodItem.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _MacroBadge(label: 'P: ${meal.totalProtein.toStringAsFixed(0)}g', color: AppColors.proteinColor),
                                  const SizedBox(width: 6),
                                  _MacroBadge(label: 'C: ${meal.totalCarbs.toStringAsFixed(0)}g', color: AppColors.carbsColor),
                                  const SizedBox(width: 6),
                                  _MacroBadge(label: 'F: ${meal.totalFat.toStringAsFixed(0)}g', color: AppColors.fatColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${meal.totalCalories} kcal',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                              onPressed: () => appState.removeLoggedMeal(meal.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 28),

            // Food Catalog Section
            Text(
              'Explore Food Library',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  borderRadius: 18,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          food.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.fastfood, color: Colors.white54),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              food.servingSize,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _MacroBadge(label: 'P: ${food.protein.toStringAsFixed(0)}g', color: AppColors.proteinColor),
                                const SizedBox(width: 6),
                                _MacroBadge(label: 'C: ${food.carbs.toStringAsFixed(0)}g', color: AppColors.carbsColor),
                                const SizedBox(width: 6),
                                _MacroBadge(label: 'F: ${food.fat.toStringAsFixed(0)}g', color: AppColors.fatColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${food.calories}',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                          const Text('kcal', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 6),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primaryNeon,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(36, 36),
                            ),
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () {
                              appState.addLoggedMeal(food, _selectedCategoryFilter ?? food.defaultCategory);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Logged ${food.name} to ${(_selectedCategoryFilter ?? food.defaultCategory).displayName}!'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppColors.primaryNeon,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MacroBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
