import 'package:flutter/material.dart';
import 'package:GymBudy/mainpage.dart';

const Color Color1 = Color(0xFFFFFFFF);
const Color lightGray = Color(0xFF606060);
const Color Color2 = Color(0xFF303030);
const Color Color3 = Color(0xFF121212);
const Color Color4 = Color(0xFF101010);
const Color Color5 = Color(0xFF080808);
const Color brandColor = Color(0xFFFF5E00);
const Color lightOrange = Color(0xFFFFD580);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color5, // Dark background
        appBarTheme: AppBarTheme(
          backgroundColor: Color4, // A matching dark gray for AppBar
          elevation: 0,
          titleTextStyle: TextStyle(color: brandColor, fontSize: 24),
        ),
      ),
      home: const MainPage(),
    );
  }
}
