import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'grocery_list.dart';

class MealPlanner extends StatefulWidget {
  @override
  _MealPlannerState createState() => _MealPlannerState();
}

class _MealPlannerState extends State<MealPlanner> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final Map<String, Map<String, String>> mealPlans = {
    'Monday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
    'Tuesday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
    'Wednesday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
    'Thursday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
    'Friday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
    'Saturday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
    'Sunday': {'Breakfast': '', 'Lunch': '', 'Dinner': ''},
  };

  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final dbHelper = DatabaseHelper();
    final favorites = await dbHelper.fetchFavoriteRecipes();
    setState(() {
      favoriteRecipes = favorites;
    });
  }

  Future<void> _autoGenerateGroceryList() async {
    final dbHelper = DatabaseHelper();
    final mealTitles = <String>{};

    for (var day in daysOfWeek) {
      for (var mealType in ['Breakfast', 'Lunch', 'Dinner']) {
        final meal = mealPlans[day]?[mealType] ?? '';
        print('Meal for $day $mealType: $meal'); // Debugging statement
        if (meal.isNotEmpty) {
          mealTitles.add(meal);
        }
      }
    }

    print('Generated meal titles: $mealTitles'); // Debugging statement

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroceryList(autoGeneratedItems: mealTitles.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome),
            onPressed: _autoGenerateGroceryList,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: daysOfWeek.map((day) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: MealSection(
                            mealType: 'Breakfast',
                            favoriteRecipes: favoriteRecipes,
                            onMealChanged: (meal) {
                              setState(() {
                                mealPlans[day]?['Breakfast'] = meal;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16), // Space between Breakfast and Lunch
                        Expanded(
                          child: MealSection(
                            mealType: 'Lunch',
                            favoriteRecipes: favoriteRecipes,
                            onMealChanged: (meal) {
                              setState(() {
                                mealPlans[day]?['Lunch'] = meal;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0), // Space between Lunch and Dinner
                    MealSection(
                      mealType: 'Dinner',
                      favoriteRecipes: favoriteRecipes,
                      onMealChanged: (meal) {
                        setState(() {
                          mealPlans[day]?['Dinner'] = meal;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MealSection extends StatefulWidget {
  final String mealType;
  final List<Map<String, dynamic>> favoriteRecipes;
  final ValueChanged<String> onMealChanged;

  MealSection({
    required this.mealType,
    required this.favoriteRecipes,
    required this.onMealChanged,
  });

  @override
  _MealSectionState createState() => _MealSectionState();
}

class _MealSectionState extends State<MealSection> {
  String selectedMeal = '';
  late List<Map<String, dynamic>> _dropdownItems;

  @override
  void initState() {
    super.initState();
    // Copy favorite recipes to _dropdownItems initially
    _dropdownItems = List.from(widget.favoriteRecipes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.mealType,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          hint: Text('Select your ${widget.mealType}'),
          value: selectedMeal.isEmpty ? null : selectedMeal,
          items: [
            // Add favorite recipes and custom meals as DropdownMenuItems
            ..._dropdownItems.map((recipe) {
              return DropdownMenuItem<String>(
                value: recipe['title'],
                child: Text(recipe['title']),
              );
            }).toList(),
            DropdownMenuItem<String>(
              value: 'Custom Input',
              child: Text('Custom Input'),
            ),
          ],
          onChanged: (value) {
            if (value == 'Custom Input') {
              _showCustomInputDialog(context);
            } else if (value != null) {
              setState(() {
                selectedMeal = value;
                widget.onMealChanged(selectedMeal);
              });
            }
          },
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  void _showCustomInputDialog(BuildContext context) {
    String customMeal = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Custom Meal'),
          content: TextField(
            onChanged: (value) {
              customMeal = value;
            },
            decoration: InputDecoration(hintText: 'Enter meal name'),
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
                if (customMeal.isNotEmpty) {
                  setState(() {
                    selectedMeal = customMeal;
                    widget.onMealChanged(selectedMeal);
                    // Temporarily add custom meal to _dropdownItems for this session
                    if (!_dropdownItems.any((item) => item['title'] == customMeal)) {
                      _dropdownItems.add({'title': customMeal});
                    }
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
