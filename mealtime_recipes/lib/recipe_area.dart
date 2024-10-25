import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'recipe_details.dart'; // Import RecipeDetails
import 'favorites_page.dart';

class RecipeArea extends StatefulWidget {
  @override
  _RecipeAreaState createState() => _RecipeAreaState();
}

class _RecipeAreaState extends State<RecipeArea> {
  Future<List<Map<String, dynamic>>> fetchRecipes([String query = '']) async {
    final db = await DatabaseHelper().database;
    if (query.isNotEmpty) {
      print('Searching for: $query'); // Log the search query
      final results = await db.query(
        'recipes',
        where: 'title LIKE ? OR ingredients LIKE ? OR dietary_tags LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
      );
      print('Search results: $results'); // Log the search results
      return results;
    }
    return await db.query('recipes');
  }

  Future<void> toggleFavorite(int id, int isFavorite) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.toggleFavorite(id, isFavorite);
    setState(() {});
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Area'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: RecipeSearchDelegate(fetchRecipes, toggleFavorite),
              );
            },
          ),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRecipes(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return Center(child: Text('No recipes found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return ListTile(
                  leading: Image.network(recipe['image']),
                  title: Text(recipe['title']),
                  trailing: IconButton(
                    icon: Icon(
                      recipe['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                      color: recipe['isFavorite'] == 1 ? Colors.red : null,
                    ),
                    onPressed: () {
                      toggleFavorite(recipe['id'], recipe['isFavorite'] == 1 ? 0 : 1);
                    },
                  ),
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

class RecipeSearchDelegate extends SearchDelegate {
  final Future<List<Map<String, dynamic>>> Function(String) fetchRecipes;
  final Future<void> Function(int, int) toggleFavorite;

  RecipeSearchDelegate(this.fetchRecipes, this.toggleFavorite);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRecipes(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
          return Center(child: Text('No recipes found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final recipe = snapshot.data![index];
              return ListTile(
                leading: Image.network(recipe['image']),
                title: Text(recipe['title']),
                trailing: IconButton(
                  icon: Icon(
                    recipe['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                    color: recipe['isFavorite'] == 1 ? Colors.red : null,
                  ),
                  onPressed: () {
                    toggleFavorite(recipe['id'], recipe['isFavorite'] == 1 ? 0 : 1);
                  },
                ),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}