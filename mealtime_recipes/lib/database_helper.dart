import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1, // Incremented version number
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT UNIQUE,
        name TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY,
        title TEXT,
        image TEXT,
        ingredients TEXT,
        instructions TEXT,
        isFavorite INTEGER,
        dietary_tags TEXT
      )
    ''');
  }

  // User registration
  Future<void> registerUser(String username, String name, String password) async {
    final db = await database;
    await db.insert('users', {'username': username, 'name': name, 'password': password});
  }

  // User login
  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    try {
      print('Attempting to log in user: $username');
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      print('Query result: $result');
      if (result.isNotEmpty) {
        return result.first;
      }
    } catch (e) {
      print('Error during login: $e');
    }
    return null;
  }

  // Update user password
  Future<void> updateUserPassword(int id, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert a single recipe into the database
  Future<void> insertRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    await db.insert('recipes', recipe, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert sample recipes into the database
  Future<void> insertSampleRecipes() async {
    final db = await database;

    final sampleRecipes = [
      {
        'title': 'Spaghetti Carbonara',
        'image': 'assets/carbonara.png',
        'ingredients': 'Spaghetti, Eggs, Parmesan, Pancetta, Pepper',
        'instructions': 'Boil pasta. Cook pancetta. Mix eggs and cheese. Combine all.',
        'isFavorite': 0,
        'dietary_tags': 'gluten free'
      },
      {
        'title': 'Vegan Tacos',
        'image': 'assets/tacos.png',
        'ingredients': 'Tortillas, Black Beans, Corn, Avocado, Salsa',
        'instructions': 'Warm tortillas. Fill with beans, corn, avocado, and salsa.',
        'isFavorite': 0,
        'dietary_tags': 'vegan'
      },
      {
        'title': 'Chicken Curry',
        'image': 'assets/curry.png',
        'ingredients': 'Chicken, Curry Powder, Coconut Milk, Onions, Garlic, Ginger',
        'instructions': 'Cook onions, garlic, and ginger. Add chicken and curry powder. Add coconut milk and simmer.',
        'isFavorite': 0,
        'dietary_tags': 'gluten free'
      },
      {
        'title': 'Beef Stroganoff',
        'image': 'assets/stroganoff.png',
        'ingredients': 'Beef, Mushrooms, Onions, Sour Cream, Beef Broth',
        'instructions': 'Cook beef and onions. Add mushrooms and broth. Stir in sour cream.',
        'isFavorite': 0,
        'dietary_tags': 'gluten free'
      },
      {
        'title': 'Caesar Salad',
        'image': 'assets/salad.png',
        'ingredients': 'Romaine Lettuce, Caesar Dressing, Croutons, Parmesan Cheese',
        'instructions': 'Toss lettuce with dressing. Add croutons and cheese.',
        'isFavorite': 0,
        'dietary_tags': 'vegetarian'
      },
      {
        'title': 'Margherita Pizza',
        'image': 'assets/pizza.png',
        'ingredients': 'Pizza Dough, Tomato Sauce, Mozzarella, Basil',
        'instructions': 'Spread sauce on dough. Add cheese and basil. Bake.',
        'isFavorite': 0,
        'dietary_tags': 'vegetarian'
      },
      {
        'title': 'Grilled Salmon',
        'image': 'assets/salmon.png',
        'ingredients': 'Salmon, Olive Oil, Lemon, Garlic, Dill',
        'instructions': 'Marinate salmon. Grill until cooked.',
        'isFavorite': 0,
        'dietary_tags': 'gluten free'
      },
      {
        'title': 'Pancakes',
        'image': 'assets/pancakes.png',
        'ingredients': 'Flour, Eggs, Milk, Baking Powder, Sugar',
        'instructions': 'Mix ingredients. Cook on griddle.',
        'isFavorite': 0,
        'dietary_tags': 'vegetarian'
      },
      {
        'title': 'Tomato Soup',
        'image': 'assets/soup.png',
        'ingredients': 'Tomatoes, Onions, Garlic, Basil, Cream',
        'instructions': 'Cook tomatoes, onions, and garlic. Blend and add cream.',
        'isFavorite': 0,
        'dietary_tags': 'vegetarian'
      },
      {
        'title': 'Chocolate Cake',
        'image': 'assets/cake.png',
        'ingredients': 'Flour, Cocoa Powder, Sugar, Eggs, Butter',
        'instructions': 'Mix ingredients. Bake.',
        'isFavorite': 0,
        'dietary_tags': 'vegetarian'
      },
    ];

    for (var recipe in sampleRecipes) {
      await db.insert('recipes', recipe, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Fetch all recipes or search by query
  Future<List<Map<String, dynamic>>> fetchRecipes([String query = '']) async {
    final db = await database;
    if (query.isNotEmpty) {
      return await db.query(
        'recipes',
        where: 'title LIKE ? OR ingredients LIKE ? OR dietary_tags LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
      );
    }
    return await db.query('recipes');
  }

  // Fetch favorite recipes
  Future<List<Map<String, dynamic>>> fetchFavoriteRecipes() async {
    final db = await database;
    return await db.query('recipes', where: 'isFavorite = ?', whereArgs: [1]);
  }

  // Fetch ingredients by recipe title
  Future<List<String>> fetchIngredientsByTitle(String title) async {
    final db = await database;
    final result = await db.query(
      'recipes',
      columns: ['ingredients'],
      where: 'LOWER(title) = ?',
      whereArgs: [title.toLowerCase()],
    );
    if (result.isNotEmpty) {
      final ingredients = result.first['ingredients'] as String;
      print('Fetched ingredients for $title: $ingredients'); // Debugging statement
      return ingredients.split(', ');
    }
    return [];
  }

  // Update favorite status of a recipe
  Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    final db = await database;
    await db.update(
      'recipes',
      {'isFavorite': isFavorite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toggle favorite status of a recipe
  Future<void> toggleFavorite(int id, int isFavorite) async {
    await updateFavoriteStatus(id, isFavorite);
  }
}