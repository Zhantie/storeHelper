import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductCarousel extends StatefulWidget {
  const ProductCarousel({Key? key}) : super(key: key);

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    for (int i = 0; i < 8; i++) {
      String barcode = '8718907384599$i'; // Replace with your barcodes
      ProductQueryConfiguration configuration =
          ProductQueryConfiguration(
              barcode,
              language: OpenFoodFactsLanguage.DUTCH,
              fields: [
                ProductField.NAME,
                ProductField.IMAGES,
              ],
              version: ProductQueryVersion.v3);
      ProductResultV3 result =
          await OpenFoodAPIClient.getProductV3(configuration);

      if (result.status == 1) {
        setState(() {
          products.add(result.product!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
      ),
      items: products.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 171, 171, 171)),
                child: Column(
                  children: [
                    Text(
                      product.productName ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Image.network(product.images.toString()),
                  ],
                ));
          },
        );
      }).toList(),
    );
  }
}
