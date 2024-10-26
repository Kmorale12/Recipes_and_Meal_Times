import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper
import 'recipe_details.dart'; // Import RecipeDetails to navigate to it

class RecipeArea extends StatefulWidget {
  @override
  _RecipeAreaState createState() => _RecipeAreaState();
}

class _RecipeAreaState extends State<RecipeArea> {
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes(); // Fetch recipes when this screen loads
  }

  // Function to fetch recipes from the database
  Future<void> fetchRecipes() async {
    final dbHelper = DatabaseHelper();
    final List<Map<String, dynamic>> fetchedRecipes = await dbHelper.fetchRecipes();
    setState(() {
      recipes = fetchedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Area'),
      ),
      body: recipes.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if recipes are not yet loaded
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  leading: Image.asset(
                    recipe['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(recipe['title']),
                  subtitle: Text(recipe['dietary_tags'] ?? ''),
                  onTap: () {
                    // Navigate to RecipeDetails with the recipe details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetails(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
