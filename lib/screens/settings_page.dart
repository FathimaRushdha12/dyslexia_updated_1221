import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFCB6CE6), // Themed AppBar color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCB6CE6), Color(0xFFF3FAFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildSettingsTile(
              icon: Icons.volume_up,
              title: 'Volume',
              onTap: () {
                // Handle volume settings
              },
            ),
            _buildSettingsTile(
              icon: Icons.image,
              title: 'Image Quality',
              onTap: () {
                // Handle image quality settings
              },
            ),
            _buildSettingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              onTap: () {
                // Handle dark mode settings
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Handle log out
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFCB6CE6)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
