import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    "Gluten",
    "Nuts",
    "Peanuts",
    "Sesame-seeds",
    "Soybeans",
    "Celery",
    "Mustard",
    "Fish",
  ];

  final Map<String, FaIcon> _categoryIcons = {
    "Eggs": const FaIcon(FontAwesomeIcons.egg),
    'Milk': const FaIcon(FontAwesomeIcons.glassWhiskey),
    "Gluten": const FaIcon(FontAwesomeIcons.breadSlice),
    "Nuts": const FaIcon(FontAwesomeIcons.disease),
    "Peanuts": const FaIcon(FontAwesomeIcons.disease),
    "Sesame-seeds": const FaIcon(FontAwesomeIcons.seedling),
    "Soybeans": const FaIcon(FontAwesomeIcons.seedling),
    "Celery": const FaIcon(FontAwesomeIcons.leaf),
    "Mustard": const FaIcon(FontAwesomeIcons.bottleDroplet),
    "Fish": const FaIcon(FontAwesomeIcons.fish),
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
                side: BorderSide(color: Colors.grey.shade400),
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
                _categoryIcons[category]?.icon,
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
