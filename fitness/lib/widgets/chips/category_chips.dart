import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({Key? key}) : super(key: key);

  @override
  _CategoryChipsState createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final List<String> _categories = [
    'Groenten',
    'Fruit',
    'Vlees',
    'Zuivel',
    'Bakkerij',
    'Dranken',
  ];

  final Map<String, IconData> _categoryIcons = {
    'Groenten': Icons.local_florist,
    'Fruit': Icons.shopping_basket,
    'Vlees': Icons.fastfood,
    'Zuivel': Icons.local_drink,
    'Bakkerij': Icons.bakery_dining,
    'Dranken': Icons.local_bar,
  };

  List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((String category) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: FilterChip(
              elevation: 4.0,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(4.0),
              ),
              selectedColor: Theme.of(context).colorScheme.secondary,
              label: Text(
                category,
                style: TextStyle(
                  color: _selectedCategories.contains(category)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              avatar: Icon(
                _categoryIcons[category],
                color: _selectedCategories.contains(category)
                    ? Colors.white
                    : Colors.black,
              ),
              selected: _selectedCategories.contains(category),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
