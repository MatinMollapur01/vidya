import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(VidyaApp());
}

class VidyaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidya',
      theme: ThemeData.light(), // Default theme is light
      darkTheme: ThemeData.dark(), // Dark theme
      home: HomeScreen(),
    );
  }
}
