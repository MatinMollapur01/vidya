import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) toggleDarkMode;

  const SettingsScreen({Key? key, required this.toggleDarkMode}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkModeEnabled;

  @override
  void initState() {
    super.initState();
    _darkModeEnabled = false; // Initialize with false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SwitchListTile(
        title: Text('Dark Mode'),
        value: _darkModeEnabled,
        onChanged: (value) {
          setState(() {
            _darkModeEnabled = value;
            widget.toggleDarkMode(value);
          });
        },
      ),
    );
  }
}