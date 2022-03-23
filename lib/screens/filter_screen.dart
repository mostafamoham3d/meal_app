import 'package:flutter/material.dart';
import 'package:meal_app/screens/main_drawer.dart';

class FilterScreen extends StatefulWidget {
  final saveFilters;
  final Map currentFilters;
  static const routeName = '/filters';
  FilterScreen(this.saveFilters, this.currentFilters);
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Widget getSwitchList(
      String title, String description, onTap, bool currentValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(description),
      value: currentValue,
      onChanged: onTap,
    );
  }

  bool isGlutenFree = false;
  bool isLactoseFree = false;
  bool isVegan = false;
  bool isVegetarian = false;

  @override
  void initState() {
    isGlutenFree = widget.currentFilters['gluten'];
    isLactoseFree = widget.currentFilters['lactose'];
    isVegan = widget.currentFilters['vegan'];
    isVegetarian = widget.currentFilters['vegetarian'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorites'),
        actions: [
          IconButton(
            onPressed: () {
              final selectedFilters = {
                'gluten': isGlutenFree,
                'lactose': isLactoseFree,
                'vegetarian': isVegetarian,
                'vegan': isVegan,
              };
              widget.saveFilters(selectedFilters);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                getSwitchList('Gluten-free', 'Only include gluten free meals',
                    (value) {
                  setState(() {
                    isGlutenFree = value;
                  });
                }, isGlutenFree),
                getSwitchList('Lactose-free', 'Only include lactose free meals',
                    (value) {
                  setState(() {
                    isLactoseFree = value;
                  });
                }, isLactoseFree),
                getSwitchList(
                    'Vegetarian', 'Only include vegetarian free meals',
                    (value) {
                  setState(() {
                    isVegetarian = value;
                  });
                }, isVegetarian),
                getSwitchList('Vegan', 'Only include vegan free meals',
                    (value) {
                  setState(() {
                    isVegan = value;
                  });
                }, isVegan)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
