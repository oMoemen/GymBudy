import 'package:flutter/material.dart';
import 'workoutfunctions.dart';

class Day2 extends StatelessWidget {
  const Day2({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutDay(dayName: 'Day 2', storageKey: 'day2_workouts');
  }
}
