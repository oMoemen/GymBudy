import 'package:flutter/material.dart';
import 'workoutfunctions.dart';

class Day1 extends StatelessWidget {
  const Day1({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutDay(dayName: 'Day 1', storageKey: 'widget.storageKey');
  }
}
