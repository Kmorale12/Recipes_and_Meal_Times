import 'package:flutter/material.dart';

class GroceryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      body: ListView(
        children: <Widget>[
          // List of grocery items
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new item
        },
        child: Icon(Icons.add),
      ),
    );
  }
}