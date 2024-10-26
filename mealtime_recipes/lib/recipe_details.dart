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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Load the image in a larger size
            Image.asset(
              recipe['image'], // Ensure this path is correct
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300, // Set a larger height for detail view
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe['title'],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ingredients:\n${recipe['ingredients']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Instructions:\n${recipe['instructions']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (recipe['dietary_tags'] != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Dietary Tags: ${recipe['dietary_tags']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
