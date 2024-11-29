class WorkoutPlan {
  final String name;
  final String description;
  final List<Exercise> exercises;
  final int duration;
  final String? targetMuscle;
  final String? fitnessLevel;

  WorkoutPlan({
    required this.name,
    required this.description,
    required this.exercises,
    required this.duration,
    this.targetMuscle,
    this.fitnessLevel,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      name: json['name'] as String? ?? 'Unnamed Workout',
      description: json['description'] as String? ?? 'No description available',
      exercises: (json['exercises'] as List? ?? [])
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      duration: json['duration'] as int? ?? 0,
      targetMuscle: json['targetMuscle'] as String?,
      fitnessLevel: json['fitnessLevel'] as String?,
    );
  }
}

class Exercise {
  final String name;
  final String description;
  final int sets;
  final int reps;

  Exercise({
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String? ?? 'Unnamed Exercise',
      description: json['description'] as String? ?? 'No description available',
      sets: json['sets'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
    );
  }
}