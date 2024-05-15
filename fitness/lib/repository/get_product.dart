import 'dart:async';
import 'package:openfoodfacts/openfoodfacts.dart';

Future<Product?> getProduct(String barcode, {OpenFoodFactsLanguage language = OpenFoodFactsLanguage.DUTCH}) async {
  final ProductQueryConfiguration configuration = ProductQueryConfiguration(
    barcode,
    language: language,
    fields: [ProductField.ALL],
    version: ProductQueryVersion.v3,
  );
  final ProductResultV3 result =
      await OpenFoodAPIClient.getProductV3(configuration);

  if (result.status == ProductResultV3.statusSuccess) {
    return result.product;
  } else {
    return null;
  }
}