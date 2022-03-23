import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/auth_screen.dart';
import 'package:meal_app/screens/category_meal_screen.dart';
import 'package:meal_app/screens/filter_screen.dart';
import 'package:meal_app/screens/meal_detail_screen.dart';
import 'package:meal_app/screens/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };

  void setFilters(Map<String, bool> _filterData) {
    setState(() {
      _filters = _filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] == true && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] == true && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegetarian'] == true && !meal.isVegetarian) {
          return false;
        }
        if (_filters['vegan'] == true && !meal.isVegan) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> favoriteMeals = [];
  late String id;
  Future<void> fetchData() async {
    final uri =
        'https://meal-project-a3799-default-rtdb.firebaseio.com/meal.json';
    try {
      final res = await http.get(Uri.parse(uri));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        setState(() {
          id = value['id'];
          final existingIndex = DUMMY_MEALS.indexWhere((meal) => id == meal.id);
          if (existingIndex >= 0) {
            favoriteMeals..add(DUMMY_MEALS.firstWhere((meal) => id == meal.id));
          }
        });
      });
    } catch (e) {
      // throw e;
      print(e);
    }
  }

  void toggleFavorites(String mealId) {
    final existingIndex = favoriteMeals.indexWhere((meal) => mealId == meal.id);
    final secondIndex = DUMMY_MEALS.indexWhere((meal) => mealId == meal.id);
    if (existingIndex >= 0) {
      final String url =
          'https://meal-project-a3799-default-rtdb.firebaseio.com/meal/${favoriteMeals[existingIndex].fireId}.json';
      http.delete(Uri.parse(url)).then((value) {
        setState(() {
          favoriteMeals.removeAt(existingIndex);
        });
      });
    } else {
      final String url =
          'https://meal-project-a3799-default-rtdb.firebaseio.com/meal.json';

      http
          .post(Uri.parse(url),
              body: json.encode({
                'id': _availableMeals[secondIndex].id,
              }))
          .then((value) {
        setState(() {
          favoriteMeals
              .add(DUMMY_MEALS.firstWhere((meal) => mealId == meal.id));
          favoriteMeals[favoriteMeals.indexWhere((meal) => mealId == meal.id)]
              .fireId = json.decode(value.body)['name'];
          print(favoriteMeals[secondIndex].fireId);
          print(secondIndex);
          print(existingIndex);
        });
      });
    }
  }

  bool isFavorite(String id) {
    return favoriteMeals.any((meal) => id == meal.id);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //authToken = Provider.of<Auth>(context).token!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // '/': (context) => BottomTabScreen(favoriteMeals),
        CategoryMealScreen.routeName: (context) =>
            CategoryMealScreen(_availableMeals),
        MealDetailScreen.routeName: (context) =>
            MealDetailScreen(toggleFavorites, isFavorite),
        FilterScreen.routeName: (context) => FilterScreen(setFilters, _filters)
      },
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              title: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed',
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
            ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return BottomTabScreen(favoriteMeals);
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal app'),
      ),
      body: null,
    );
  }
}
