import 'package:flutter/material.dart';
import 'dart:async';
import '../models/workout_plan.dart';

class WorkoutTimerScreen extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutTimerScreen({
    super.key,
    required this.workoutPlan,
  });

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  int _currentExerciseIndex = 0;
  bool _isResting = false;
  bool _isRunning = false;
  int _timeRemaining = 0;
  Timer? _timer;

  static const int exerciseTime = 45;
  static const int restTime = 15;

  @override
  void initState() {
    super.initState();
    _timeRemaining = exerciseTime;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
          } else {
            if (_isResting) {
              if (_currentExerciseIndex < widget.workoutPlan.exercises.length - 1) {
                _currentExerciseIndex++;
                _timeRemaining = exerciseTime;
                _isResting = false;
              } else {
                _timer?.cancel();
                _showWorkoutComplete();
                return;
              }
            } else {
              _timeRemaining = restTime;
              _isResting = true;
            }
          }
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _showWorkoutComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete! 🎉'),
        content: const Text('Congratulations on completing your workout!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.workoutPlan.exercises[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('End Workout?'),
                content: const Text('Are you sure you want to end this workout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Continue'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('End Workout'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentExerciseIndex + (_timeRemaining / (_isResting ? restTime : exerciseTime))) /
                widget.workoutPlan.exercises.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _isResting ? Colors.orange : Theme.of(context).primaryColor,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isResting ? 'REST' : 'EXERCISE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _isResting ? Colors.orange : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    currentExercise.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exercise ${_currentExerciseIndex + 1} of ${widget.workoutPlan.exercises.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isResting ? Colors.orange : Theme.of(context).primaryColor,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _formatTime(_timeRemaining),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (!_isResting) ...[
                    Text(
                      '${currentExercise.sets} sets × ${currentExercise.reps} reps',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_currentExerciseIndex < widget.workoutPlan.exercises.length - 1)
                    Text(
                      'Next: ${widget.workoutPlan.exercises[_currentExerciseIndex + 1].name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleTimer,
        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
        label: Text(_isRunning ? 'Pause' : 'Start'),
        backgroundColor: _isResting ? Colors.orange : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}