import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum MealCategory { breakfast, lunch, dinner, snack }

extension MealCategoryExtension on MealCategory {
  String get displayName {
    switch (this) {
      case MealCategory.breakfast:
        return 'Breakfast';
      case MealCategory.lunch:
        return 'Lunch';
      case MealCategory.dinner:
        return 'Dinner';
      case MealCategory.snack:
        return 'Snacks';
    }
  }

  IconData get icon {
    switch (this) {
      case MealCategory.breakfast:
        return Icons.wb_sunny_rounded;
      case MealCategory.lunch:
        return Icons.restaurant_rounded;
      case MealCategory.dinner:
        return Icons.nights_stay_rounded;
      case MealCategory.snack:
        return Icons.local_cafe_rounded;
    }
  }
}

class FoodItem {
  final String id;
  final String name;
  final int calories;
  final double protein; // grams
  final double carbs; // grams
  final double fat; // grams
  final String servingSize;
  final String imageUrl;
  final MealCategory defaultCategory;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.imageUrl,
    this.defaultCategory = MealCategory.lunch,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'servingSize': servingSize,
        'imageUrl': imageUrl,
        'defaultCategory': defaultCategory.index,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'],
        name: json['name'],
        calories: json['calories'],
        protein: (json['protein'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
        servingSize: json['servingSize'],
        imageUrl: json['imageUrl'],
        defaultCategory: MealCategory.values[json['defaultCategory'] ?? 1],
      );
}

class LoggedMeal {
  final String id;
  final DateTime timestamp;
  final MealCategory category;
  final FoodItem foodItem;
  final double servings;

  LoggedMeal({
    required this.id,
    required this.timestamp,
    required this.category,
    required this.foodItem,
    this.servings = 1.0,
  });

  int get totalCalories => (foodItem.calories * servings).round();
  double get totalProtein => foodItem.protein * servings;
  double get totalCarbs => foodItem.carbs * servings;
  double get totalFat => foodItem.fat * servings;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'category': category.index,
        'foodItem': foodItem.toJson(),
        'servings': servings,
      };

  factory LoggedMeal.fromJson(Map<String, dynamic> json) => LoggedMeal(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        category: MealCategory.values[json['category']],
        foodItem: FoodItem.fromJson(json['foodItem']),
        servings: (json['servings'] as num).toDouble(),
      );
}

class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final String category; // Strength, Cardio, HIIT, Mobility
  final int caloriesBurnedPerMin;
  final String imageUrl;
  final String description;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.category,
    required this.caloriesBurnedPerMin,
    required this.imageUrl,
    required this.description,
  });
}

class WorkoutSet {
  int reps;
  double weightKg;
  bool isCompleted;

  WorkoutSet({
    required this.reps,
    required this.weightKg,
    this.isCompleted = false,
  });
}

class ExerciseLog {
  final Exercise exercise;
  final List<WorkoutSet> sets;

  ExerciseLog({
    required this.exercise,
    required this.sets,
  });
}

class WorkoutSession {
  final String id;
  final String name;
  final DateTime timestamp;
  final int durationMinutes;
  final int caloriesBurned;
  final List<String> exerciseNames;

  WorkoutSession({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.exerciseNames,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'timestamp': timestamp.toIso8601String(),
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        'exerciseNames': exerciseNames,
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'],
        name: json['name'],
        timestamp: DateTime.parse(json['timestamp']),
        durationMinutes: json['durationMinutes'],
        caloriesBurned: json['caloriesBurned'],
        exerciseNames: List<String>.from(json['exerciseNames']),
      );
}

enum ActivityLevel {
  sedentary, // Little/no exercise
  lightlyActive, // 1-3 days/week
  moderatelyActive, // 3-5 days/week
  veryActive, // 6-7 days/week
  extraActive, // Athlete / 2x training
}

extension ActivityLevelExtension on ActivityLevel {
  String get title {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary (Desk job, minimal exercise)';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active (1-3 days/week)';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active (3-5 days/week)';
      case ActivityLevel.veryActive:
        return 'Very Active (6-7 days/week)';
      case ActivityLevel.extraActive:
        return 'Extra Active (Hard exercise/sports)';
    }
  }

  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }
}

enum FitnessGoal { fatLoss, maintenance, muscleGain }

extension FitnessGoalExtension on FitnessGoal {
  String get title {
    switch (this) {
      case FitnessGoal.fatLoss:
        return 'Fat Loss (Calorie Deficit)';
      case FitnessGoal.maintenance:
        return 'Maintain Weight';
      case FitnessGoal.muscleGain:
        return 'Muscle Growth (Calorie Surplus)';
    }
  }

  int get calorieAdjustment {
    switch (this) {
      case FitnessGoal.fatLoss:
        return -500;
      case FitnessGoal.maintenance:
        return 0;
      case FitnessGoal.muscleGain:
        return 350;
    }
  }
}

class UserProfile {
  String name;
  String gender; // 'Male' or 'Female'
  int age;
  double heightCm;
  double weightKg;
  double targetWeightKg;
  ActivityLevel activityLevel;
  FitnessGoal fitnessGoal;

  int calorieTarget;
  double proteinTarget; // grams
  double carbsTarget; // grams
  double fatTarget; // grams
  int waterTargetMl;

  UserProfile({
    this.name = 'Alex Hunter',
    this.gender = 'Male',
    this.age = 26,
    this.heightCm = 178.0,
    this.weightKg = 75.0,
    this.targetWeightKg = 72.0,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.fitnessGoal = FitnessGoal.fatLoss,
    this.calorieTarget = 2300,
    this.proteinTarget = 160.0,
    this.carbsTarget = 230.0,
    this.fatTarget = 65.0,
    this.waterTargetMl = 3000,
  });
}

class BmiResult {
  final double bmi;
  final String category;
  final String idealWeightRange;
  final String message;
  final Color color;

  BmiResult({
    required this.bmi,
    required this.category,
    required this.idealWeightRange,
    required this.message,
    required this.color,
  });

  factory BmiResult.calculate(double weightKg, double heightCm) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);

    final minIdeal = 18.5 * (heightM * heightM);
    final maxIdeal = 24.9 * (heightM * heightM);
    final rangeStr = '${minIdeal.toStringAsFixed(1)} - ${maxIdeal.toStringAsFixed(1)} kg';

    if (bmi < 18.5) {
      return BmiResult(
        bmi: bmi,
        category: 'Underweight',
        idealWeightRange: rangeStr,
        message: 'Consider increasing caloric intake with nutrient-dense foods & strength training.',
        color: AppColors.bmiUnderweight,
      );
    } else if (bmi <= 24.9) {
      return BmiResult(
        bmi: bmi,
        category: 'Optimal / Normal Weight',
        idealWeightRange: rangeStr,
        message: 'Excellent! Your weight is in a healthy range for your height. Keep up the balance!',
        color: AppColors.bmiNormal,
      );
    } else if (bmi <= 29.9) {
      return BmiResult(
        bmi: bmi,
        category: 'Overweight',
        idealWeightRange: rangeStr,
        message: 'Slightly above recommended range. Moderate calorie deficit & steady cardio is recommended.',
        color: AppColors.bmiOverweight,
      );
    } else {
      return BmiResult(
        bmi: bmi,
        category: 'Obese',
        idealWeightRange: rangeStr,
        message: 'High risk range. Focus on sustainable lifestyle changes, balanced macros, and daily activity.',
        color: AppColors.bmiObese,
      );
    }
  }
}
