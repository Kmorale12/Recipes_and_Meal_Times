import 'package:flutter/material.dart';
import 'recipe_area.dart';
import 'meal_planner.dart';
import 'grocery_list.dart';
import 'settings_screen.dart'; // Import SettingsScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeArea()),
                );
              },
              child: Text('Recipe Area'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlanner()),
                );
              },
              child: Text('Meal Planner'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroceryList()),
                );
              },
              child: Text('Grocery List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}