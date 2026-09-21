import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;

  // Theme State
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // User Profile
  UserProfile _userProfile = UserProfile();
  UserProfile get userProfile => _userProfile;

  // Meal Logs
  final List<LoggedMeal> _loggedMeals = [];
  List<LoggedMeal> get loggedMeals => List.unmodifiable(_loggedMeals);

  // Water Hydration (mL)
  int _waterIntakeMl = 1750;
  int get waterIntakeMl => _waterIntakeMl;

  // Workout Sessions
  final List<WorkoutSession> _workoutSessions = [];
  List<WorkoutSession> get workoutSessions => List.unmodifiable(_workoutSessions);

  // Available Foods Catalog
  final List<FoodItem> _customFoods = [];
  List<FoodItem> get allFoods => [...MockData.defaultFoods, ..._customFoods];

  // Weight History Log (Date string -> weightKg)
  final Map<String, double> _weightHistory = {
    'Mon': 76.5,
    'Tue': 76.2,
    'Wed': 75.8,
    'Thu': 75.5,
    'Fri': 75.2,
    'Sat': 75.1,
    'Sun': 75.0,
  };
  Map<String, double> get weightHistory => _weightHistory;

  AppState() {
    _initStorage();
    _loadSampleDataIfEmpty();
  }

  Future<void> _initStorage() async {
    _prefs = await SharedPreferences.getInstance();
    final isDark = _prefs?.getBool('is_dark_mode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    _waterIntakeMl = _prefs?.getInt('water_intake_ml') ?? 1750;

    final mealsJson = _prefs?.getStringList('logged_meals');
    if (mealsJson != null && mealsJson.isNotEmpty) {
      _loggedMeals.clear();
      for (var itemStr in mealsJson) {
        try {
          _loggedMeals.add(LoggedMeal.fromJson(jsonDecode(itemStr)));
        } catch (_) {}
      }
    }

    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    _prefs?.setBool('is_dark_mode', isDarkMode);
    notifyListeners();
  }

  // Today's Macro Metrics
  List<LoggedMeal> get todayLoggedMeals {
    final now = DateTime.now();
    return _loggedMeals.where((m) {
      return m.timestamp.year == now.year &&
          m.timestamp.month == now.month &&
          m.timestamp.day == now.day;
    }).toList();
  }

  int get todayConsumedCalories {
    return todayLoggedMeals.fold(0, (sum, m) => sum + m.totalCalories);
  }

  double get todayConsumedProtein {
    return todayLoggedMeals.fold(0.0, (sum, m) => sum + m.totalProtein);
  }

  double get todayConsumedCarbs {
    return todayLoggedMeals.fold(0.0, (sum, m) => sum + m.totalCarbs);
  }

  double get todayConsumedFat {
    return todayLoggedMeals.fold(0.0, (sum, m) => sum + m.totalFat);
  }

  int get todayBurnedCalories {
    final now = DateTime.now();
    final todayWorkouts = _workoutSessions.where((w) {
      return w.timestamp.year == now.year &&
          w.timestamp.month == now.month &&
          w.timestamp.day == now.day;
    });
    return todayWorkouts.fold(350, (sum, w) => sum + w.caloriesBurned); // default base + workout
  }

  // Log Meal
  void addLoggedMeal(FoodItem food, MealCategory category, {double servings = 1.0}) {
    final newMeal = LoggedMeal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      category: category,
      foodItem: food,
      servings: servings,
    );
    _loggedMeals.add(newMeal);
    _saveMeals();
    notifyListeners();
  }

  void removeLoggedMeal(String mealId) {
    _loggedMeals.removeWhere((m) => m.id == mealId);
    _saveMeals();
    notifyListeners();
  }

  void _saveMeals() {
    final listStr = _loggedMeals.map((m) => jsonEncode(m.toJson())).toList();
    _prefs?.setStringList('logged_meals', listStr);
  }

  // Hydration
  void addWater(int amountMl) {
    _waterIntakeMl = (_waterIntakeMl + amountMl).clamp(0, 10000);
    _prefs?.setInt('water_intake_ml', _waterIntakeMl);
    notifyListeners();
  }

  void resetWater() {
    _waterIntakeMl = 0;
    _prefs?.setInt('water_intake_ml', 0);
    notifyListeners();
  }

  // Add Custom Food
  void addCustomFood(FoodItem food) {
    _customFoods.add(food);
    notifyListeners();
  }

  // Workouts
  void addWorkoutSession(WorkoutSession session) {
    _workoutSessions.insert(0, session);
    notifyListeners();
  }

  // Profile Updates
  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void updateBiometrics({
    required double heightCm,
    required double weightKg,
    required int age,
    required String gender,
    required ActivityLevel activityLevel,
    required FitnessGoal fitnessGoal,
  }) {
    _userProfile.heightCm = heightCm;
    _userProfile.weightKg = weightKg;
    _userProfile.age = age;
    _userProfile.gender = gender;
    _userProfile.activityLevel = activityLevel;
    _userProfile.fitnessGoal = fitnessGoal;

    // Recalculate BMR & TDEE automatically!
    recalculateTdeeAndMacros();
    notifyListeners();
  }

  void recalculateTdeeAndMacros() {
    // Mifflin-St Jeor Equation
    double bmr;
    if (_userProfile.gender.toLowerCase() == 'male') {
      bmr = (10 * _userProfile.weightKg) + (6.25 * _userProfile.heightCm) - (5 * _userProfile.age) + 5;
    } else {
      bmr = (10 * _userProfile.weightKg) + (6.25 * _userProfile.heightCm) - (5 * _userProfile.age) - 161;
    }

    final tdee = bmr * _userProfile.activityLevel.multiplier;
    final targetCals = (tdee + _userProfile.fitnessGoal.calorieAdjustment).round();

    _userProfile.calorieTarget = targetCals;

    // Standard high-protein split: 30% Protein, 40% Carbs, 30% Fat
    _userProfile.proteinTarget = ((targetCals * 0.30) / 4.0); // 4 cals/g protein
    _userProfile.carbsTarget = ((targetCals * 0.40) / 4.0); // 4 cals/g carbs
    _userProfile.fatTarget = ((targetCals * 0.30) / 9.0); // 9 cals/g fat

    notifyListeners();
  }

  void _loadSampleDataIfEmpty() {
    if (_loggedMeals.isEmpty) {
      _loggedMeals.addAll([
        LoggedMeal(
          id: 'sample_1',
          timestamp: DateTime.now(),
          category: MealCategory.breakfast,
          foodItem: MockData.defaultFoods[2], // Avocado Toast
        ),
        LoggedMeal(
          id: 'sample_2',
          timestamp: DateTime.now(),
          category: MealCategory.lunch,
          foodItem: MockData.defaultFoods[0], // Grilled Chicken
        ),
        LoggedMeal(
          id: 'sample_3',
          timestamp: DateTime.now(),
          category: MealCategory.snack,
          foodItem: MockData.defaultFoods[4], // Greek Yogurt
        ),
      ]);
    }

    if (_workoutSessions.isEmpty) {
      _workoutSessions.add(
        WorkoutSession(
          id: 'ws_1',
          name: 'Hypertrophy Chest & Triceps',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          durationMinutes: 52,
          caloriesBurned: 420,
          exerciseNames: ['Barbell Bench Press', 'Dumbbell Shoulder Press', 'Push-Ups'],
        ),
      );
    }
  }
}
