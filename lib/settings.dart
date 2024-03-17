import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = false; // Initial value for dark mode

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
            // You can implement dark mode functionality here
          });
        },
      ),
    );
  }
}
