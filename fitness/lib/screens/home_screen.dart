import 'package:fitness/repository/get_product.dart';
import 'package:fitness/scaffolds/base_scaffold.dart';
import 'package:fitness/screens/camera/camera_barcode_screen.dart';
import 'package:fitness/screens/chat_screen.dart';
import 'package:fitness/views/camera_view.dart';
import 'package:fitness/widgets/carousel/product_carousel.dart';
import 'package:fitness/widgets/chips/category_chips.dart';
import 'package:fitness/widgets/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _scanResult = '';
  String? _barcode;
  String? productName;
  String? productImage;
  String? productBrand;
  String? productQuantitiy;
  bool isLoading = false;

  Future<String?> getScanCode() async {
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

  void scanCode() async {
    String? barcodeScanResult = await getScanCode();

    setState(() {
      isLoading = true; // Begin met laden voordat de scan begint
    });

    if (barcodeScanResult == null) {
      print('Barcode scanning failed');
      return;
    }

    print('Scanned barcode: $barcodeScanResult');
    setState(() {
      _barcode = barcodeScanResult;
    });

    // Create a ProductQueryConfiguration with the scanned barcode
    ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcodeScanResult,
      country: OpenFoodFactsCountry.NETHERLANDS,
      language: OpenFoodFactsLanguage.DUTCH,
      fields: [
        ProductField.ALL,
      ],
      version: ProductQueryVersion.v3,
    );

    // Fetch the product from the Open Food Facts API
    try {
      ProductResultV3 result =
          await OpenFoodAPIClient.getProductV3(configuration);

      // Check if the product was found and store the product information
      if (result.status == ProductResultV3.statusSuccess &&
          result.product != null) {
        print('Product found: ${result.product!.productName}');
        setState(() {
          isLoading = false;
          productName = result.product!.productName;
          productImage = result.product!.imageFrontUrl;
          productBrand = result.product!.brands;
          productQuantitiy = result.product!.quantity;
        });
      } else {
        print('Product not found');
        setState(() {
          productName = 'Product not found';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching product: $e');
      setState(() {
        productName = 'Error fetching product: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          scanCode();
        },
        label: const Text('Scan product'),
        icon: const Icon(Icons.qr_code_scanner),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Supermarket help',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    'Zoek product informatie op',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const Searchfield(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: CategoryChips(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Scanned product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //card with product information
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 150, // Stel de gewenste hoogte in
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Row(
                                children: [
                                  if (productImage != null)
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                        ),
                                        child: Image.network(productImage!))
                                  else
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productName?.toString() ?? '',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            productQuantitiy?.toString() ?? '',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(
                                                    150,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            productBrand?.toString() ?? '',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
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
