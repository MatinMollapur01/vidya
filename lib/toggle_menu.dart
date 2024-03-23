import 'package:flutter/material.dart';
import 'settings.dart';
import 'bookmarks_page.dart';

class ToggleMenu extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
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