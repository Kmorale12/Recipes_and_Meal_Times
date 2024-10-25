import 'package:flutter/material.dart';

class MealPlanner extends StatelessWidget {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
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
                    MealSection(mealType: 'Breakfast'),
                    MealSection(mealType: 'Lunch'),
                    MealSection(mealType: 'Dinner'),
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

class MealSection extends StatelessWidget {
  final String mealType;

  MealSection({required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          mealType,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your $mealType',
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}