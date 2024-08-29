import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  const SettingsScreen({Key? key, required this.isDarkMode, required this.toggleDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (bool value) {
                toggleDarkMode(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}