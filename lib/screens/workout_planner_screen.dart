import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class WorkoutPlannerScreen extends StatefulWidget {
  const WorkoutPlannerScreen({super.key});

  @override
  State<WorkoutPlannerScreen> createState() => _WorkoutPlannerScreenState();
}

class _WorkoutPlannerScreenState extends State<WorkoutPlannerScreen> {
  String _selectedMuscleFilter = 'All';

  // Active workout state
  bool _isWorkoutActive = false;
  final List<ExerciseLog> _activeExerciseLogs = [];

  final _workoutNameController = TextEditingController(text: 'Upper Body Blast');

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final workoutSessions = appState.workoutSessions;

    final allExercises = MockData.defaultExercises;
    final filteredExercises = allExercises.where((e) {
      if (_selectedMuscleFilter == 'All') return true;
      return e.muscleGroup.toLowerCase().contains(_selectedMuscleFilter.toLowerCase()) ||
          e.category.toLowerCase().contains(_selectedMuscleFilter.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Planner & Logger', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isWorkoutActive)
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryNeon),
              icon: const Icon(Icons.play_circle_fill_rounded, size: 22),
              label: const Text('START WORKOUT', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  _isWorkoutActive = true;
                  _activeExerciseLogs.clear();
                  _activeExerciseLogs.add(
                    ExerciseLog(
                      exercise: MockData.defaultExercises[0], // Bench Press
                      sets: [
                        WorkoutSet(reps: 10, weightKg: 70.0, isCompleted: true),
                        WorkoutSet(reps: 8, weightKg: 80.0, isCompleted: true),
                        WorkoutSet(reps: 6, weightKg: 85.0, isCompleted: false),
                      ],
                    ),
                  );
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ACTIVE WORKOUT MODE CONTAINER
            if (_isWorkoutActive) ...[
              GlassCard(
                customBgColor: appState.isDarkMode ? AppColors.darkSurfaceLight : AppColors.lightSurfaceSecondary,
                borderSide: const BorderSide(color: AppColors.primaryNeon, width: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.fiber_manual_record_rounded, color: Colors.redAccent, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'WORKOUT IN PROGRESS',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isWorkoutActive = false),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _workoutNameController,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Workout Session Title',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Exercises in active workout
                    ..._activeExerciseLogs.map((log) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.exercise.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          ...log.sets.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final set = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                children: [
                                  Text('Set ${idx + 1}: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(width: 8),
                                  Text('${set.weightKg} kg × ${set.reps} reps', style: const TextStyle(fontSize: 14)),
                                  const Spacer(),
                                  Checkbox(
                                    value: set.isCompleted,
                                    activeColor: AppColors.primaryNeon,
                                    checkColor: Colors.black,
                                    onChanged: (val) {
                                      setState(() => set.isCompleted = val ?? false);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),

                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNeon,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text('FINISH & LOG WORKOUT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                        onPressed: () {
                          final session = WorkoutSession(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: _workoutNameController.text.trim(),
                            timestamp: DateTime.now(),
                            durationMinutes: 45,
                            caloriesBurned: 380,
                            exerciseNames: _activeExerciseLogs.map((e) => e.exercise.name).toList(),
                          );
                          appState.addWorkoutSession(session);
                          setState(() => _isWorkoutActive = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Awesome job! Workout logged successfully!'),
                              backgroundColor: AppColors.primaryNeon,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Muscle Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Chest', 'Legs', 'Back', 'Shoulders', 'HIIT'].map((muscle) {
                  final isSelected = muscle == _selectedMuscleFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(muscle),
                      selected: isSelected,
                      selectedColor: AppColors.primaryNeon,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : null,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedMuscleFilter = muscle),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Exercise Library Cards
            Text('Exercise Database', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            ...filteredExercises.map((exercise) {
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                borderRadius: 18,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        exercise.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade800,
                          child: const Icon(Icons.fitness_center, color: Colors.white54),
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryNeon.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  exercise.muscleGroup.toUpperCase(),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryNeon),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${exercise.caloriesBurnedPerMin} kcal/min',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            exercise.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                    if (_isWorkoutActive)
                      IconButton(
                        icon: const Icon(Icons.add_circle_rounded, color: AppColors.primaryNeon, size: 28),
                        onPressed: () {
                          setState(() {
                            _activeExerciseLogs.add(
                              ExerciseLog(
                                exercise: exercise,
                                sets: [
                                  WorkoutSet(reps: 10, weightKg: 50.0),
                                  WorkoutSet(reps: 10, weightKg: 50.0),
                                ],
                              ),
                            );
                          });
                        },
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Workout History
            Text('Recent Workout History', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            ...workoutSessions.map((session) {
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(session.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          '${session.caloriesBurned} kcal',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryCoral, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${session.durationMinutes} mins', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 14),
                        const Icon(Icons.fitness_center_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${session.exerciseNames.length} exercises', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
