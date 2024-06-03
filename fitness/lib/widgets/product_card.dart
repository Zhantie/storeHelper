import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String? productName;
  final String? productImage;
  final String? productBrand;
  final String? productQuantitiy;

  const ProductCard({
    super.key,
    this.productName,
    this.productImage,
    this.productBrand,
    this.productQuantitiy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      elevation: 10,
      child: Column(
        children: [
          Expanded(
            flex: 4,  
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
                child: Image.network(
                  productImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                AutoSizeText(
                  productName ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                  maxLines: 1,
                ),
                AutoSizeText(
                  productQuantitiy ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary.withAlpha(
                              150,
                            ),
                      ),
                  maxFontSize: 12.0,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
