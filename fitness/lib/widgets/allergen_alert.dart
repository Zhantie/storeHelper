import 'package:flutter/material.dart';

class AllergenAlert {
  static void show(BuildContext context, String allergen) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Waarschuwing!'),
          content: Text('Dit product bevat allergenen: $allergen'),
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
