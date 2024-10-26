import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final int userId;

  SettingsScreen({required this.userId});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  final _passwordController = TextEditingController();

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _updatePassword() async {
    final newPassword = _passwordController.text;
    await DatabaseHelper().updateUserPassword(widget.userId, newPassword);
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password updated successfully')),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
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
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Update Password'),
                  content: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _updatePassword();
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}