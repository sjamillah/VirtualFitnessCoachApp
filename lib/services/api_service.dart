import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/workout_plan.dart';

class ApiService {
  static const String baseUrl = 'https://wger.de/api/v2';

  void _logError(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('ApiService Error: $message');
      if (error != null) debugPrint(error.toString());
    }
  }

  Future<List<WorkoutPlan>> fetchWorkoutPlans({
    required List<String> equipment,
    required String fitnessGoal,
    required int duration,
  }) async {
    try {
      final equipmentIds = await getEquipmentIds(equipment);

      final queryParams = {
        'equipment': equipmentIds.join(','),
        'language': '2',
        'limit': '20',
        'status': '2',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/exercise/').replace(queryParameters: queryParams),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['results'] is List && (data['results'] as List).isNotEmpty) {
          final exercises = data['results'] as List;
          return _createWorkoutPlans(exercises, duration, fitnessGoal);
        }
      }
      return [];
    } catch (e) {
      _logError('Error fetching workout plans', e);
      return [];
    }
  }

  Future<List<int>> getEquipmentIds(List<String> equipmentNames) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipment/'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final equipmentList = data['results'] as List;

        return equipmentList
            .where((equipment) {
          if (equipment is Map<String, dynamic> && equipment.containsKey('name')) {
            return equipmentNames.any((name) =>
                name.toLowerCase().contains(equipment['name'].toString().toLowerCase()));
          }
          return false;
        })
            .map<int>((equipment) => equipment['id'] as int)
            .toList();
      }
      return [];
    } catch (e) {
      _logError('Error getting equipment IDs', e);
      return [];
    }
  }

  String _cleanDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'No description available';
    }

    String cleaned = description;

    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    final regex = RegExp(r'\\u([0-9A-Fa-f]{4})');
    cleaned = cleaned.replaceAllMapped(regex, (Match match) {
      final hexCode = match.group(1)!;
      return String.fromCharCode(int.parse(hexCode, radix: 16));
    });

    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    final htmlEntities = {
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#39;': "'",
      '&nbsp;': ' ',
    };

    htmlEntities.forEach((entity, replacement) {
      cleaned = cleaned.replaceAll(entity, replacement);
    });

    cleaned = cleaned.trim();
    return cleaned.isEmpty ? 'No description available' : cleaned;
  }

  String _createWorkoutDescription({
    required String muscleGroup,
    required String fitnessGoal,
    required int duration,
    required int exerciseCount,
    required int timePerExercise,
  }) {
    return '''Duration: $duration minutes
Focus: $muscleGroup
Goal: $fitnessGoal
Number of Exercises: $exerciseCount
Time per Exercise: ~$timePerExercise minutes''';
  }

  List<WorkoutPlan> _createWorkoutPlans(List exercises, int duration, String fitnessGoal) {
    try {
      final Map<String, List<Map<String, dynamic>>> groupedExercises = {};

      for (var exercise in exercises) {
        if (exercise is Map<String, dynamic>) {
          String category = 'General';

          if (exercise['muscles'] is List && (exercise['muscles'] as List).isNotEmpty) {
            final muscleData = exercise['muscles'][0];
            if (muscleData is Map<String, dynamic>) {
              category = (muscleData['name_en'] as String?) ??
                  (muscleData['name'] as String?) ??
                  'General';
            }
          }

          if (!groupedExercises.containsKey(category)) {
            groupedExercises[category] = [];
          }

          exercise['description'] = _cleanDescription(exercise['description'] as String?);
          groupedExercises[category]!.add(exercise);
        }
      }

      List<WorkoutPlan> workoutPlans = [];

      for (var entry in groupedExercises.entries) {
        final exerciseList = entry.value.take(6).map((e) => Exercise(
          name: e['name']?.toString() ?? 'Unnamed Exercise',
          description: e['description'] as String,
          sets: determineSets(fitnessGoal),
          reps: determineReps(fitnessGoal),
        )).toList();

        if (exerciseList.isNotEmpty) {
          final timePerExercise = (duration / exerciseList.length).round();

          workoutPlans.add(WorkoutPlan(
            name: '${entry.key} Workout',
            description: _createWorkoutDescription(
              muscleGroup: entry.key,
              fitnessGoal: fitnessGoal,
              duration: duration,
              exerciseCount: exerciseList.length,
              timePerExercise: timePerExercise,
            ),
            exercises: exerciseList,
            duration: duration,
            targetMuscle: entry.key,
            fitnessLevel: fitnessGoal,
          ));
        }
      }

      return workoutPlans;
    } catch (e) {
      _logError('Error creating workout plans', e);
      return [];
    }
  }

  int determineSets(String fitnessGoal) {
    switch (fitnessGoal.toLowerCase()) {
      case 'strength':
        return 4;
      case 'endurance':
        return 3;
      case 'weight loss':
        return 4;
      default:
        return 3;
    }
  }

  int determineReps(String fitnessGoal) {
    switch (fitnessGoal.toLowerCase()) {
      case 'strength':
        return 8;
      case 'endurance':
        return 15;
      case 'weight loss':
        return 12;
      default:
        return 10;
    }
  }
}