import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/equipment_data_provider.dart';
import '../providers/workout_provider.dart';
import '../main.dart';

class WorkoutIllustration extends StatelessWidget {
  final bool isDarkMode;

  const WorkoutIllustration({
    super.key,
    required this.isDarkMode,
  });

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF172A3A) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.purple[600]!, Colors.blue[600]!]
              : [Colors.purple[400]!, Colors.blue[400]!],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.purple.withOpacity(0.3)
                    : Colors.purple[100]?.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -15,
            bottom: -15,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.blue[100]?.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fitness_center,
                size: 64,
                color: isDarkMode ? Colors.purple[300] : Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'Personalized Workout Plans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gear up and sculpt your dream physique!',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[300] : Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    icon: Icons.timer,
                    title: "30-120 min",
                    subtitle: "Workouts",
                    isDarkMode: isDarkMode,
                  ),
                  _buildStatItem(
                    icon: Icons.sports_gymnastics,
                    title: "Multiple",
                    subtitle: "Equipment Options",
                    isDarkMode: isDarkMode,
                  ),
                  _buildStatItem(
                    icon: Icons.track_changes,
                    title: "Various",
                    subtitle: "Fitness Goals",
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final equipmentData = context.watch<EquipmentDataProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Virtual Fitness Coach',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(
                themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.isDarkMode
                ? null
                : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF0F7FF), Color(0xFFF5F0FF)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    WorkoutIllustration(isDarkMode: themeProvider.isDarkMode),
                    Card(
                      elevation: themeProvider.isDarkMode ? 4 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: themeProvider.isDarkMode
                          ? const Color(0xFF1F2937)
                          : Colors.white.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: workoutProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Create Your Plan',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Equipment',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: themeProvider.isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: themeProvider.isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              value: workoutProvider.selectedEquipment.isEmpty
                                  ? null
                                  : 'Basic',
                              items: ['Basic', 'Full Gym']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                if (value == 'Basic') {
                                  workoutProvider.updateEquipment(
                                      equipmentData.basicGymEquipment);
                                } else if (value == 'Full Gym') {
                                  workoutProvider.updateEquipment(
                                      equipmentData.fullGymEquipment);
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Fitness Goal',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: themeProvider.isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: themeProvider.isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              value: workoutProvider.fitnessGoal.isEmpty
                                  ? null
                                  : workoutProvider.fitnessGoal,
                              items: ['Strength', 'Endurance', 'Weight Loss']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  workoutProvider.updateFitnessGoal(value);
                                }
                              },
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'Duration: ${workoutProvider.duration} minutes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 4,
                                thumbColor: themeProvider.isDarkMode
                                    ? Colors.purple[300]
                                    : Colors.purple[400],
                                activeTrackColor: themeProvider.isDarkMode
                                    ? Colors.purple[300]
                                    : Colors.purple[400],
                                inactiveTrackColor: themeProvider.isDarkMode
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                              ),
                              child: Slider(
                                value: workoutProvider.duration.toDouble(),
                                min: 30,
                                max: 120,
                                divisions: 6,
                                label: '${workoutProvider.duration} min',
                                onChanged: (value) {
                                  workoutProvider.updateDuration(value.round());
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              height: 56,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: themeProvider.isDarkMode
                                        ? [Colors.purple[700]!, Colors.blue[700]!]
                                        : [Colors.purple[500]!, Colors.blue[500]!],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeProvider.isDarkMode
                                          ? Colors.purple.withOpacity(0.3)
                                          : Colors.purple.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: workoutProvider.selectedEquipment.isNotEmpty &&
                                      workoutProvider.fitnessGoal.isNotEmpty
                                      ? () {
                                    workoutProvider.fetchWorkoutPlans().then((_) {
                                      Navigator.pushNamed(context, '/workout-plans');
                                    });
                                  }
                                      : null,
                                  child: const Text(
                                    'Get Workout Plans',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (workoutProvider.error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  workoutProvider.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}