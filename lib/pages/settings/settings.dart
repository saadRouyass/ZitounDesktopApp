import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _aiEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
             const SizedBox(height: 20),
            // Page title
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            // --- Appearance ---
            _sectionTitle("Appearance"),
            Card(
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text("Light Theme"),
                    value: ThemeMode.light,
                    groupValue: _themeMode,
                    onChanged: (value) {
                      setState(() => _themeMode = value!);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text("Dark Theme"),
                    value: ThemeMode.dark,
                    groupValue: _themeMode,
                    onChanged: (value) {
                      setState(() => _themeMode = value!);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Features ---
            _sectionTitle("Features"),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Enable AI Chatbot"),
                    subtitle: const Text("Get smart assistance inside the app"),
                    value: _aiEnabled,
                    onChanged: (value) {
                      setState(() => _aiEnabled = value);
                    },
                    secondary: const Icon(Icons.smart_toy_outlined),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- General ---
            _sectionTitle("General"),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Notifications"),
                    subtitle: const Text("Receive important updates"),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                    },
                    secondary: const Icon(Icons.notifications_outlined),
                  ),
                  SwitchListTile(
                    title: const Text("Auto Sync"),
                    subtitle: const Text("Sync data automatically"),
                    value: _autoSyncEnabled,
                    onChanged: (value) {
                      setState(() => _autoSyncEnabled = value);
                    },
                    secondary: const Icon(Icons.sync),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Language"),
                    subtitle: const Text("Francais"),
                    onTap: () {
                      // Navigate to language page
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Account ---
            _sectionTitle("Account"),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text("Change Password"),
                    onTap: () {
                      // Navigate to change password
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text("Privacy Policy"),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Logout ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: theme.colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _logout(context);
              },
              child: const Text(
                "Disconnect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Clear tokens / session
    // Navigate to login page
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
