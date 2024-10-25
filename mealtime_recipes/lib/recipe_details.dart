import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetails({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(recipe['image']),
            SizedBox(height: 16.0),
            Text(
              recipe['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(recipe['ingredients']),
            SizedBox(height: 16.0),
            Text(
              'Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(recipe['instructions']),
          ],
        ),
      ),
    );
  }
}