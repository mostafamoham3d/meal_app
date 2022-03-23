import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/favorites.dart';

import 'category_screen.dart';
import 'main_drawer.dart';

class BottomTabScreen extends StatefulWidget {
  final List<Meal> favMeals;
  BottomTabScreen(this.favMeals);
  @override
  _BottomTabScreenState createState() => _BottomTabScreenState();
}

class _BottomTabScreenState extends State<BottomTabScreen> {
  late List<Map> _pages;
  int selectedIndex = 0;
  final iconList = <IconData>[
    Icons.category,
    Icons.star,
  ];
  @override
  void initState() {
    _pages = [
      {
        'page': CategoryScreen(),
        'title': 'Categories',
      },
      {
        'page': Favorites(widget.favMeals),
        'title': 'Favorites',
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('${_pages[selectedIndex]['title']}'),
      ),
      body: _pages[selectedIndex]['page'],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).accentColor,
        inactiveColor: Colors.white,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        gapLocation: GapLocation.none,
        splashColor: Theme.of(context).accentColor,
        splashRadius: 32,
      ),
    );
  }
}
