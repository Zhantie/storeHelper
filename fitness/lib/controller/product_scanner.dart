import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductScanner {
  static Future<String?> getScanCode() async {
    try {
      return await FlutterBarcodeScanner.scanBarcode(
        '#00B295',
        'Terug',
        false,
        ScanMode.BARCODE,
      );
    } catch (e) {
      print('Error scanning barcode: $e');
      return null;
    }
  }

  static Future<Map<String, String>?> fetchProduct(String barcode) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      country: OpenFoodFactsCountry.NETHERLANDS,
      language: OpenFoodFactsLanguage.DUTCH,
      fields: [
        ProductField.ALL,
      ],
      version: ProductQueryVersion.v3,
    );

    try {
      ProductResultV3 result = await OpenFoodAPIClient.getProductV3(configuration);

      if (result.status == ProductResultV3.statusSuccess && result.product != null) {
        return {
          'name': result.product!.productName ?? '',
          'image': result.product!.imageFrontUrl ?? '',
          'brand': result.product!.brands ?? '',
          'quantity': result.product!.quantity ?? '',
          'allergens': result.product!.allergens?.names.join(', ') ?? '',
        };
      } else {
        print('Product not found');
        return null;
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
}
