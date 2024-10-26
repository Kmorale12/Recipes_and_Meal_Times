import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites(); // Fetch favorite recipes when this screen loads
  }

  // Function to fetch favorite recipes from the database
  Future<void> fetchFavorites() async {
    final dbHelper = DatabaseHelper();
    final List<Map<String, dynamic>> fetchedFavorites = await dbHelper.fetchFavoriteRecipes();
    setState(() {
      favoriteRecipes = fetchedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(child: Text('No favorite recipes yet'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return ListTile(
                  leading: Image.asset(
                    recipe['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(recipe['title']),
                  subtitle: Text(recipe['dietary_tags'] ?? ''),
                );
              },
            ),
    );
  }
}