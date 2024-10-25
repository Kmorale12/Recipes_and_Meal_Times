import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'recipe_details.dart';

class FavoritesPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchFavoriteRecipes() async {
    final db = await DatabaseHelper().database;
    return await db.query('recipes', where: 'isFavorite = ?', whereArgs: [1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return Center(child: Text('No favorite recipes found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return ListTile(
                  leading: Image.network(recipe['image']),
                  title: Text(recipe['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetails(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}