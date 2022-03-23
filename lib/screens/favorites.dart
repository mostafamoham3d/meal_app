import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/widgets/meal_item.dart';

class Favorites extends StatefulWidget {
  final List<Meal> favMeals;
  Favorites(this.favMeals);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late String id;

  Future<void> fetchData() async {
    const uri =
        'https://meal-project-a3799-default-rtdb.firebaseio.com/meal.json';
    try {
      final res = await http.get(Uri.parse(uri));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        setState(() {
          id = value['id'];
        });
      });
      final existingIndex = DUMMY_MEALS.indexWhere((meal) => id == meal.id);
      if (existingIndex >= 0) {
        widget.favMeals..add(DUMMY_MEALS.firstWhere((meal) => id == meal.id));
      }
    } catch (e) {
      // throw e;
      print(e);
    }
  }

  @override
  void initState() {
    // fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.favMeals.isEmpty) {
      return Center(
        child: Text('You have no favorites yet - start adding some'),
      );
    } else {
      return ListView.builder(
          itemBuilder: (context, index) {
            return MealItem(
              id: widget.favMeals[index].id,
              imageUrl: widget.favMeals[index].imageUrl,
              title: widget.favMeals[index].title,
              duration: widget.favMeals[index].duration,
              complexity: widget.favMeals[index].complexity,
              affordability: widget.favMeals[index].affordability,
            );
          },
          itemCount: widget.favMeals.length);
    }
  }
}
