import 'package:flutter/material.dart';

class GroceryItem {
  String name;
  bool isChecked;

  GroceryItem({required this.name, this.isChecked = false});
}

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  void _addItem(String name) {
    setState(() {
      _groceryItems.add(GroceryItem(name: name));
    });
  }

  void _toggleItemChecked(int index) {
    setState(() {
      _groceryItems[index].isChecked = !_groceryItems[index].isChecked;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _groceryItems.removeAt(index);
    });
  }

  void _clearAllItems() {
    setState(() {
      _groceryItems.clear();
    });
  }

  void _autoGenerateItems() {
    // Implement auto-generate items based on meal plans and selected recipes
    // For now, let's add some sample items
    setState(() {
      _groceryItems.addAll([
        GroceryItem(name: 'Milk'),
        GroceryItem(name: 'Eggs'),
        GroceryItem(name: 'Bread'),
      ]);
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
          IconButton(
            icon: Icon(Icons.auto_awesome),
            onPressed: _autoGenerateItems,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          final item = _groceryItems[index];
          return ListTile(
            leading: Checkbox(
              value: item.isChecked,
              onChanged: (bool? value) {
                _toggleItemChecked(index);
              },
            ),
            title: Text(
              item.name,
              style: TextStyle(
                decoration: item.isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteItem(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}