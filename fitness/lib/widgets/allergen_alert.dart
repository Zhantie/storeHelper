import 'package:flutter/material.dart';

class AllergenAlert {
  static void show(BuildContext context, String allergen, String productName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Text('Allergen Detected!'),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.warning_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
          content: Text('$productName contains $allergen'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
