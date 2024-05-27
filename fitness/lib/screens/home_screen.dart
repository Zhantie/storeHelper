import 'package:fitness/controller/product_scanner.dart';
import 'package:fitness/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:fitness/scaffolds/base_scaffold.dart';
import 'package:fitness/widgets/chips/category_chips.dart';
import 'package:fitness/widgets/searchfield.dart';
import 'package:fitness/widgets/product_details_card.dart';
import 'package:fitness/widgets/allergen_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _barcode;
  String? productName;
  String? productImage;
  String? productBrand;
  String? productQuantitiy;
  String? productAllergens;
  bool isLoading = false;

  List<String> selectedAllergens = [];
  List<Map<String, String?>> scannedProducts = [];

  void scanCode() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    String? barcodeScanResult = await ProductScanner.getScanCode();

    if (barcodeScanResult == null) {
      print('Barcode scanning failed');
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      _barcode = barcodeScanResult;
    });

    try {
      var result = await ProductScanner.fetchProduct(barcodeScanResult);
      if (result != null) {
        setState(() {
          isLoading = false;
          productName = result['name'];
          productImage = result['image'];
          productBrand = result['brand'];
          productQuantitiy = result['quantity'];
          productAllergens = result['allergens'];

          scannedProducts.add({
            'name': productName,
            'image': productImage,
            'brand': productBrand,
            'quantity': productQuantitiy,
          });
        });

        // Check for allergens
        if (selectedAllergens.isNotEmpty && productAllergens != null) {
          for (var allergen in selectedAllergens) {
            if (productAllergens!
                .toLowerCase()
                .contains(allergen.toLowerCase())) {
              showAllergenAlert(allergen);
              break;
            }
          }
        }
      } else {
        setState(() {
          productName = 'Product not found';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching product: $e');
      setState(() {
        productName = 'Error fetching product: $e';
        isLoading = false;
      });
    }
  }

  void showAllergenAlert(String allergen) {
    AllergenAlert.show(context, allergen);
  }

  void handleSelectionChanged(List<String> selected) {
    setState(() {
      selectedAllergens = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: scanCode,
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
      body: ListView(
        children: [
          Container(
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
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            alignment: Alignment.topCenter,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    'Allergens',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: CategoryChips(
                      onSelectionChanged: handleSelectionChanged),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: SizedBox(
                    height: 150,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ProductDetailsCard(
                            productName: productName,
                            productImage: productImage,
                            productBrand: productBrand,
                            productQuantitiy: productQuantitiy,
                          ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    'Recent scans',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 1.7,
                    crossAxisSpacing: 10,
                    children: scannedProducts.map((product) {
                      return ProductCard(
                        productName: product['name'],
                        productImage: product['image'],
                        productBrand: product['brand'],
                        productQuantitiy: product['quantity'],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
