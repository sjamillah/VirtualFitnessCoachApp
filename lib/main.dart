import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/equipment_data_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/flash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workout_plan_screen.dart';
import 'screens/workout_details_screen.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(const VirtualFitnessCoachApp());
}

class VirtualFitnessCoachApp extends StatelessWidget {
  const VirtualFitnessCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EquipmentDataProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Virtual Fitness Coach',
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/home': (context) => const HomeScreen(),
              '/workout-plans': (context) => WorkoutPlanScreen(),
              '/workout-details': (context) => WorkoutDetailsScreen(),
            },
          );
        },
      ),
    );
  }
}