import 'package:flutter/material.dart';
import '../models/workout_plan.dart';
import '../services/api_service.dart';

class WorkoutProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = false;
  String? _error;
  List<String> _selectedEquipment = [];
  String _fitnessGoal = '';
  int _duration = 30;

  List<WorkoutPlan> get workoutPlans => _workoutPlans;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get selectedEquipment => _selectedEquipment;
  String get fitnessGoal => _fitnessGoal;
  int get duration => _duration;

  void updateEquipment(List<String> equipment) {
    _selectedEquipment = equipment;
    notifyListeners();
  }

  void updateFitnessGoal(String goal) {
    _fitnessGoal = goal;
    notifyListeners();
  }

  void updateDuration(int duration) {
    _duration = duration;
    notifyListeners();
  }

  Future<void> fetchWorkoutPlans() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _workoutPlans = await _apiService.fetchWorkoutPlans(
        equipment: _selectedEquipment,
        fitnessGoal: _fitnessGoal,
        duration: _duration,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearWorkoutPlans() {
    _workoutPlans = [];
    notifyListeners();
  }
}