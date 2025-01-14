import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import DatabaseHelper

class GroceryItem {
  String name;
  bool isChecked;

  GroceryItem({required this.name, this.isChecked = false});
}

class GroceryList extends StatefulWidget {
  final List<String> autoGeneratedItems;

  GroceryList({required this.autoGeneratedItems});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  List<GroceryItem> _filteredGroceryItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchGroceryItems();
  }

  Future<void> _fetchGroceryItems() async {
    final dbHelper = DatabaseHelper();
    final List<GroceryItem> items = [];

    for (var recipeTitle in widget.autoGeneratedItems) {
      print('Fetching ingredients for: $recipeTitle'); // Debugging statement
      final ingredients = await dbHelper.fetchIngredientsByTitle(recipeTitle);
      print('Ingredients for $recipeTitle: $ingredients'); // Debugging statement
      for (var ingredient in ingredients) {
        items.add(GroceryItem(name: ingredient));
      }
    }

    setState(() {
      _groceryItems = items;
      _filteredGroceryItems = _groceryItems;
      print('Grocery items: $_groceryItems'); // Debugging statement
    });
  }

  void _addItem(String name) {
    setState(() {
      _groceryItems.add(GroceryItem(name: name));
      _filterGroceryItems();
      print('Added item: $name'); // Debugging statement
    });
  }

  void _toggleItemChecked(int index) {
    setState(() {
      _groceryItems[index].isChecked = !_groceryItems[index].isChecked;
      _filterGroceryItems();
      print('Toggled item: ${_groceryItems[index].name}'); // Debugging statement
    });
  }

  void _deleteItem(int index) {
    setState(() {
      print('Deleted item: ${_groceryItems[index].name}'); // Debugging statement
      _groceryItems.removeAt(index);
      _filterGroceryItems();
    });
  }

  void _clearAllItems() {
    setState(() {
      print('Cleared all items'); // Debugging statement
      _groceryItems.clear();
      _filterGroceryItems();
    });
  }

  void _filterGroceryItems() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredGroceryItems = _groceryItems;
      } else {
        _filteredGroceryItems = _groceryItems
            .where((item) =>
                item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
      print('Filtered items: $_filteredGroceryItems'); // Debugging statement
    });
  }

  void _showAddItemDialog() {
    String newItemName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItemName = value;
            },
            decoration: InputDecoration(hintText: 'Enter item name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (newItemName.isNotEmpty) {
                  _addItem(newItemName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearAllItems,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterGroceryItems();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredGroceryItems.length,
              itemBuilder: (context, index) {
                final item = _filteredGroceryItems[index];
                return Container(
                  constraints: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (bool? value) {
                        _toggleItemChecked(index);
                      },
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        decoration:
                            item.isChecked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteItem(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}