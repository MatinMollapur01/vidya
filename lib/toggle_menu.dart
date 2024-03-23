import 'package:flutter/material.dart';
import 'settings.dart';
import 'bookmarks_page.dart';

class ToggleMenu extends StatelessWidget {
  final Function(bool) toggleDarkMode;

  const ToggleMenu({Key? key, required this.toggleDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(toggleDarkMode: toggleDarkMode)), // Pass the toggleDarkMode callback
                );
              },
              child: const Text('Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookmarksPage()),
                );
              },
              child: const Text('Bookmarks'),
            ),
          ],
        ),
      ),
    );
  }
}