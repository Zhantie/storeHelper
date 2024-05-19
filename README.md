# Store helper

Store Helper is een app dat in ontwikkeling is om de winkel ervaring van klanten binnen een winkel te verbeteren.

In deze Readme laat ik Poc's zien waarbij ik ook code snippets weergeef

## Poc Product herkenning

https://github.com/Zhantie/fitnessApp/assets/74553048/c565f3c9-ade1-4b66-956a-0e43834b3452


### initCamera
In deze functie wordt de camera geïnitialiseerd. Eerst wordt gecontroleerd of de gebruiker toestemming heeft gegeven. Vervolgens wordt een beeldstream gestart en gecontroleerd op objectherkenning. In mijn geval worden een appel en banaan gedetecteerd door het getrainde model.

```dart
initCamera() async {
  if (await Permission.camera.request().isGranted) {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await cameraController.initialize().then((value) {
      cameraController.startImageStream((image) {
        cameraCount++;
        if (cameraCount % 90 == 0) {
          cameraCount = 0;
          objectDetector(image);
        }
        update();
      });
    });
    isCameraInitialized(true);
    update();
  } else {
    print('Permission denied');
  }
}
```

### Initialisatie TensorFlow & object detectie
Hier initialiseer ik mijn getrainde TensorFlow-model en controleer ik het 'confidence'-niveau. Dit betekent dat zodra het object een vertrouwensscore heeft van meer dan 96%, het als herkend wordt beschouwd.

```dart
initTFLite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );

    if (detector != null) {
      if (detector.first["confidence"] > 0.96) {
        log("Result is: $detector");
        detectedObjects.value = [
          {
            "label": detector.first["label"],
            "confidence": detector.first["confidence"],
            
          },
        ];
      }
    }
```

## Poc Chatbot
## Poc Barcode scanner
https://github.com/Zhantie/fitnessApp/assets/74553048/833f3d0b-7622-4aaf-8a82-9b4719354e38

### Barcode scanner
Voor mijn barcode scanner heb ik gebruik gemaakt van de `flutter_barcode_scanner: ^2.0.0` package. In de getScanCode functie heb ik enkele aanpassingen gedaan aan de scanner pagina. De kleur van de scanner balk is ingesteld op `#00B295` en de flits functie is uitgeschakeld, zodat deze niet gebruikt kan worden.
```dart
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
```

### OpenFoodFacts & Ophalen scanned barcode
In deze code worden barcodes gescand en wordt productinformatie opgehaald via de Open Food Facts API. De functie `scanCode` begint met het scannen van een barcode door de `getScanCode` functie aan te roepen. De status `isLoading` wordt bijgewerkt om aan te geven dat de app bezig is met het verwerken van de scan. Als het scannen mislukt, wordt een foutmelding weergegeven. Anders wordt de gescande barcode afgedrukt en opgeslagen in `_barcode`.

Vervolgens wordt een `ProductQueryConfiguration` gemaakt met de gescande barcode, waarbij Nederland als land en Nederlands als taal is ingesteld. De OpenFoodFacts API wordt aangeroepen om productinformatie op te halen. Als het product succesvol wordt gevonden, worden de productdetails (naam, afbeelding, merk, hoeveelheid) opgeslagen en weergegeven. Als het product niet wordt gevonden, wordt een melding weergegeven dat het product niet is gevonden. Bij een fout tijdens het ophalen van het product, wordt een foutmelding weergegeven en opgeslagen.

```dart
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
```



