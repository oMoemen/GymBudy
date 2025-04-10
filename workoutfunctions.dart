import 'package:flutter/material.dart';
import 'package:GymBudy/main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutItem {
  final String title;
  final String imagePath;

  WorkoutItem({required this.title, required this.imagePath});

  Map<String, dynamic> toJson() => {'title': title, 'imagePath': imagePath};

  factory WorkoutItem.fromJson(Map<String, dynamic> json) =>
      WorkoutItem(title: json['title'], imagePath: json['imagePath']);
}

class WorkoutDay extends StatefulWidget {
  final String dayName;
  final String storageKey;

  const WorkoutDay({
    super.key,
    required this.dayName,
    required this.storageKey,
  });

  @override
  State<WorkoutDay> createState() => _WorkoutDayState();
}

class _WorkoutDayState extends State<WorkoutDay> {
  List<WorkoutItem> workouts = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => isLoading = true);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      final title = await _showTitleDialog();
      if (title == null || title.isEmpty) return;

      final newWorkout = WorkoutItem(title: title, imagePath: savedImage.path);

      setState(() => workouts.add(newWorkout));
      await _saveWorkouts();
    } catch (e) {
      setState(() => errorMessage = 'Failed to pick image: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<String?> _showTitleDialog() async {
    String input = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Title'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => input = value,
          decoration: const InputDecoration(
            hintText: "Enter workout name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, input),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = workouts.map((w) => jsonEncode(w.toJson())).toList();
      await prefs.setStringList(widget.storageKey, jsonList);
    } catch (e) {
      setState(() => errorMessage = 'Failed to save workouts: ${e.toString()}');
    }
  }

  Future<void> _loadWorkouts() async {
    try {
      setState(() => isLoading = true);
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(widget.storageKey) ?? [];

      setState(() {
        workouts = jsonList
            .map((item) => WorkoutItem.fromJson(jsonDecode(item)))
            .toList();
      });
    } catch (e) {
      setState(() => errorMessage = 'Failed to load workouts: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteWorkout(int index) async {
    try {
      setState(() {
        workouts.removeAt(index);
      });
      await _saveWorkouts();
    } catch (e) {
      setState(
        () => errorMessage = 'Failed to delete workout: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.dayName,
          style: const TextStyle(
            color: Color(0xFFFF5E00),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: isLoading ? null : _pickImage,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
      );
    }

    if (workouts.isEmpty) {
      return const Center(
        child: Text(
          "No workouts yet. Tap '+' to add one!",
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Center(
          child: Dismissible(
            key: Key(workout.imagePath),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 40),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Delete Workout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Are you sure you want to delete this workout?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: brandColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) => _deleteWorkout(index),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      workout.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.file(
                      File(workout.imagePath),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
