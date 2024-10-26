import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper
import 'recipe_details.dart'; // Import RecipeDetails to navigate to it
import 'favorites_page.dart'; // Import the FavoritesPage

class RecipeArea extends StatefulWidget {
  @override
  _RecipeAreaState createState() => _RecipeAreaState();
}

class _RecipeAreaState extends State<RecipeArea> {
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> filteredRecipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes(); // Fetch recipes when this screen loads
    searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to fetch recipes from the database
  Future<void> fetchRecipes() async {
    final dbHelper = DatabaseHelper();
    final List<Map<String, dynamic>> fetchedRecipes = await dbHelper.fetchRecipes();
    setState(() {
      recipes = fetchedRecipes;
      filteredRecipes = fetchedRecipes;
    });
  }

  void _filterRecipes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredRecipes = recipes.where((recipe) {
        final title = recipe['title'].toLowerCase();
        final tags = recipe['dietary_tags']?.toLowerCase() ?? '';
        return title.contains(query) || tags.contains(query);
      }).toList();
    });
  }

  Future<void> _toggleFavorite(int id, int isFavorite) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.toggleFavorite(id, isFavorite);
    fetchRecipes(); // Refresh the recipes list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search by title or dietary tag',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: filteredRecipes.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if recipes are not yet loaded
          : ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return ListTile(
                  leading: Image.asset(
                    recipe['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(recipe['title']),
                  subtitle: Text(recipe['dietary_tags'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(
                      recipe['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                      color: recipe['isFavorite'] == 1 ? Colors.red : null,
                    ),
                    onPressed: () async {
                      await _toggleFavorite(recipe['id'], recipe['isFavorite'] == 1 ? 0 : 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${recipe['title']} ${recipe['isFavorite'] == 1 ? 'removed from' : 'added to'} favorites')),
                      );
                    },
                  ),
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