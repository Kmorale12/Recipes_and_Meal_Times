import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'login_screen.dart'; // Import LoginScreen
import 'database_helper.dart'; // Import DatabaseHelper
import 'theme_notifier.dart'; // Import ThemeNotifier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Ensure the database is initialized
  await dbHelper.insertSampleRecipes();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Recipe App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: LoginScreen(), // Start with LoginScreen
        );
      },
    );
  }
}