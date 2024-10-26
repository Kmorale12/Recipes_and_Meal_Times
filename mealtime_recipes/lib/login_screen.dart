import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() async {
    final username = _usernameController.text;
    final name = _nameController.text;
    final password = _passwordController.text;

    if (_isLogin) {
      final user = await DatabaseHelper().loginUser(username, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: user['id'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    } else {
      try {
        await DatabaseHelper().registerUser(username, name, password);
        final user = await DatabaseHelper().loginUser(username, password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: user!['id'])),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username already exists')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            if (!_isLogin)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: _toggleFormMode,
              child: Text(_isLogin ? 'Create an account' : 'Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}