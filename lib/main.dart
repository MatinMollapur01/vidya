import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final darkMode = prefs.getBool('darkMode') ?? false;
  runApp(VidyaApp(darkMode: darkMode));
}

class VidyaApp extends StatefulWidget {
  final bool darkMode;

  const VidyaApp({Key? key, required this.darkMode}) : super(key: key);

  @override
  _VidyaAppState createState() => _VidyaAppState();
}

class _VidyaAppState extends State<VidyaApp> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.darkMode;
  }

  void toggleDarkMode(bool value) async {
    setState(() {
      _darkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidya',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(toggleDarkMode: toggleDarkMode),
    );
  }
}