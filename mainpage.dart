import 'package:flutter/material.dart';
import 'package:GymBudy/day1.dart';
import 'package:GymBudy/day2.dart';
import 'package:GymBudy/day3.dart';
import 'package:GymBudy/main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GymBudy',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: brandColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            DayCard(
              day: 'Day 1',
              description: 'Start your journey with a strong mindset.',
              icon: Icons.fitness_center,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Day1()),
                );
              },
            ),
            const SizedBox(height: 10),
            DayCard(
              day: 'Day 2',
              description: 'Keep pushing forward, you\'re doing great!',
              icon: Icons.air_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Day2()),
                );
              },
            ),
            const SizedBox(height: 10),
            DayCard(
              day: 'Day 3',
              description: 'Stay consistent, it will pay off!',
              icon: Icons.access_alarm,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Day3()),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// Custom DayCard Widget
class DayCard extends StatelessWidget {
  final String day;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const DayCard({
    required this.day,
    required this.description,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Color3,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: brandColor),
                  const SizedBox(width: 10),
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: brandColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: brandColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
