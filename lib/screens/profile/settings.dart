import 'package:flutter/material.dart';
import '../../cache/settings_cache.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final cache = SettingsCache.instance;

  void _onUpdate() => setState(() {});

  @override
  void initState() {
    super.initState();
    cache.addListener(_onUpdate);
  }

  @override
  void dispose() {
    cache.removeListener(_onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark mode'),
              value: cache.darkMode,
              onChanged: cache.setDarkMode,
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.text_fields),
                      SizedBox(width: 12),
                      Text('Text size'),
                    ],
                  ),
                  Slider(
                    value: cache.textScale,
                    min: 0.85,
                    max: 1.3,
                    divisions: 9,
                    label: '${(cache.textScale * 100).round()}%',
                    onChanged: cache.setTextScale,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}