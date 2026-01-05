import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('General'),
          _settingsTile(Icons.palette, 'Theme'),
          _settingsTile(Icons.language, 'Language'),

          const SizedBox(height: 20),
          _sectionTitle('Notifications'),
          _switchTile('Family Updates'),
          _switchTile('Birthday Reminders'),

          const SizedBox(height: 20),
          _sectionTitle('App'),
          _settingsTile(Icons.info, 'About App'),
          _settingsTile(Icons.privacy_tip, 'Privacy Policy'),
          _settingsTile(Icons.help, 'Help & Support'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4CAF50)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

  Widget _switchTile(String title) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        activeColor: const Color(0xFF4CAF50),
        value: true,
        onChanged: (value) {},
      ),
    );
  }
}
