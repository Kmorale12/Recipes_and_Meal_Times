import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart'; // Import LoginScreen
import 'database_helper.dart'; // Import DatabaseHelper

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Ensure the database is initialized
  await dbHelper.insertSampleRecipes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Start with LoginScreen
    );
  }
}