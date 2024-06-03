import 'package:flutter/material.dart';

class ProductDetailsCard extends StatelessWidget {
  final String? productName;
  final String? productImage;
  final String? productBrand;
  final String? productQuantitiy;

  const ProductDetailsCard({
    Key? key,
    this.productName,
    this.productImage,
    this.productBrand,
    this.productQuantitiy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      elevation: 10,
      child: Row(
        children: [
          if (productImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  10.0,
                ),
                bottomLeft: Radius.circular(
                  10.0,
                ),
              ),
              child: Image.network(
                productImage!,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No product scanned',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary.withAlpha(150),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName ?? '',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    productQuantitiy ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(150),
                    ),
                  ),
                  Text(
                    productBrand ?? '',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
