import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _updatePassword() {
    // Implement password update functionality
  }

  void _updateEmail() {
    // Implement email update functionality
  }

  void _support() {
    // Implement support functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
          ),
          ListTile(
            title: Text('Update Password'),
            onTap: _updatePassword,
          ),
          ListTile(
            title: Text('Update Email'),
            onTap: _updateEmail,
          ),
          ListTile(
            title: Text('Support'),
            onTap: _support,
          ),
        ],
      ),
    );
  }
}