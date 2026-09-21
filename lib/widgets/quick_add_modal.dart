import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class QuickAddModal extends StatefulWidget {
  final MealCategory defaultCategory;

  const QuickAddModal({super.key, required this.defaultCategory});

  @override
  State<QuickAddModal> createState() => _QuickAddModalState();
}

class _QuickAddModalState extends State<QuickAddModal> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _servingController = TextEditingController(text: '1 portion');

  late MealCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.defaultCategory;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryNeon, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Quick Add Meal / Food',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: MealCategory.values.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.black : AppColors.primaryNeon),
                      label: Text(cat.displayName),
                      selectedColor: AppColors.primaryNeon,
                      checkmarkColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : null,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Food Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Food Name',
                hintText: 'e.g. Protein Smoothie, Egg Wrap',
                prefixIcon: const Icon(Icons.fastfood_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Calories (kcal)',
                      prefixIcon: const Icon(Icons.local_fire_department_rounded, color: AppColors.primaryCoral),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _servingController,
                    decoration: InputDecoration(
                      labelText: 'Serving Size',
                      prefixIcon: const Icon(Icons.scale_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Macros Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _proteinController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Protein (g)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _carbsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Carbs (g)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _fatController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Fat (g)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNeon,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.check_circle_rounded, size: 22),
                label: const Text('LOG MEAL NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                onPressed: () {
                  final name = _nameController.text.trim();
                  final cals = int.tryParse(_caloriesController.text.trim()) ?? 250;
                  final protein = double.tryParse(_proteinController.text.trim()) ?? 20.0;
                  final carbs = double.tryParse(_carbsController.text.trim()) ?? 25.0;
                  final fat = double.tryParse(_fatController.text.trim()) ?? 8.0;
                  final serving = _servingController.text.trim().isEmpty ? '1 portion' : _servingController.text.trim();

                  final customFood = FoodItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name.isEmpty ? 'Custom Meal' : name,
                    calories: cals,
                    protein: protein,
                    carbs: carbs,
                    fat: fat,
                    servingSize: serving,
                    imageUrl: 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=600&q=80',
                    defaultCategory: _selectedCategory,
                  );

                  appState.addLoggedMeal(customFood, _selectedCategory);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
