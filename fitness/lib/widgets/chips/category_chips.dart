import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const CategoryChips({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  _CategoryChipsState createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final List<String> categoriesAllergen = [
    "Eggs",
    'Milk',
  ];

  final Map<String, IconData> _categoryIcons = {
    "Eggs": Icons.texture_sharp,
    'Milk': Icons.texture_sharp,
  };

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categoriesAllergen.map((String category) {
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
                  color: selectedCategories.contains(category)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              avatar: Icon(
                _categoryIcons[category],
                color: selectedCategories.contains(category)
                    ? Colors.white
                    : Colors.black,
              ),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
                widget.onSelectionChanged(selectedCategories);
              },
              selected: selectedCategories.contains(category),
            ),
          );
        }).toList(),
      ),
    );
  }
}
