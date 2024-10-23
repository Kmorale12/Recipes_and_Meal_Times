import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'recipe_area.dart';
import 'meal_planner.dart';
import 'grocery_list.dart';
import 'settings_screen.dart';

void main() {
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
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/recipes': (context) => RecipeArea(),
        '/meal-planner': (context) => MealPlanner(),
        '/grocery-list': (context) => GroceryList(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}