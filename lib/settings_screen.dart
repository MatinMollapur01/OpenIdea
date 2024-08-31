import 'package:flutter/material.dart';
import 'package:openidea/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final Function(String) changeLanguage;
  final String currentLanguage;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.changeLanguage,
    required this.currentLanguage,
  });

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        // Remove the backgroundColor property to use the default app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.darkMode,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SwitchListTile(
              title: Text(localizations.darkMode),
              value: widget.isDarkMode,
              onChanged: (bool value) {
                widget.toggleDarkMode(value);
              },
            ),
            const SizedBox(height: 20),
            Text(
              localizations.language,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fa', child: Text('فارسی')),
                DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                DropdownMenuItem(value: 'az', child: Text('Azərbaycan')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'zh', child: Text('中文')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                  widget.changeLanguage(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}