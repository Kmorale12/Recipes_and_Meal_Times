import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planning App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planning App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Do nothing for Recipes button
              },
              child: Text('Recipes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Do nothing for Meal Planner button
              },
              child: Text('Meal Planner'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroceryListScreen()),
                );
              },
              child: Text('Grocery List'),
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<Map<String, dynamic>> _groceryList = [];
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _groceryList.add({'name': _controller.text, 'checked': false});
        _controller.clear();
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _groceryList.removeAt(index);
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _groceryList[index]['checked'] = !_groceryList[index]['checked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Add item'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _groceryList.length,
              itemBuilder: (context, index) {
                final item = _groceryList[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['checked'],
                    onChanged: (_) => _toggleItem(index),
                  ),
                  title: Text(
                    item['name'],
                    style: TextStyle(
                      decoration: item['checked']
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
