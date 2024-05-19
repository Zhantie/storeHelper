# Store helper

Store Helper is een app dat in ontwikkeling is om de winkel ervaring van klanten binnen een winkel te verbeteren.

In deze Readme laat ik Poc's zien waarbij ik ook code snippets weergeef

* POC TensorFlow 
* POC Chatbot
* Barcode Scanner

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
https://github.com/Zhantie/fitnessApp/assets/74553048/7b3ceeb5-f5ad-4ea9-8655-5190c8310105

### Initialisatie van OpenAI en Chat Gebruikers
In deze code wordt een OpenAI-instantie opgezet en worden twee ChatUser objecten aangemaakt. De OpenAI-instantie wordt geconfigureerd met een API-token, een ontvangst-timeout van 5 seconden en logging is ingeschakeld. Daarnaast worden er twee gebruikers voor de chat gedefinieerd: een huidige gebruiker en een GPT-chatgebruiker.
```dart
final _openAI = OpenAI.instance.build(
    token: dotenv.env['API_CHATBOT']!,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: "User",
    lastName: "last name",
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: "Supermarkt",
    lastName: "help",
  );
```

### Chatreactie verwerken 
Deze functie, `getChatResponse`, handelt binnen de app chatberichten af en haalt een reactie op van een OpenAI-chatmodel. Het proces gaat alsvolgt door het toevoegen van het ontvangen bericht aan de chatgeschiedenis vervolgens het opstellen van een verzoek aan OpenAI met de chatgeschiedenis als context, het ontvangen van een reactie van OpenAI en het toevoegen van deze reactie aan de chatgeschiedenis.
In eerste instantie was het de bedoeling om mijn getrainde model als chatbot te gebruiken, dit was me helaas nog niet gelukt waardoor ik nu de chatbot context heb mee gegeven. De context van het AI model is: 

```dart
"Als assistent binnen Albert Heijn bij filiaal Albert Heijn Buurmalseplein weet jij alles te vinden en ken jij alle locaties van elk product. Het is van cruciaal belang om vragen buiten deze scope niet te beantwoorden. Het is belangrijk om kort, snel en duidelijk te reageren, maar wel op een klantvriendelijke manier. Als een klant specifiek vraagt naar een product, leg je het bijvoorbeeld uit als gangpad 4, links, meter 2, 3e plank. Als een klant vraagt waar hij of zij een product kan vinden, leg je eerst uit waar het product zich bevindt. Als de klant aangeeft het niet te kunnen vinden, verwijs je pas door naar een medewerker. Voor allergieën geef je kort aan of het product veilig is en bied je indien mogelijk alternatieven aan. Als een product niet op voorraad is, geef je de reden, zoals een foutieve levering, kwaliteitsproblemen of een slechte oogst. Houd je antwoorden kort en vriendelijk, om efficiënt te blijven binnen de kosten per token. Vergeet niet dat het heel belangrijk is om vragen buiten deze scope niet te beantwoorden."
```

```dart
Future<void> getChatResponse(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_gptChatUser);
    });
    List<Messages> messagesHistory = _messages.reversed.map((message) {
      if (message.user == _currentUser) {
        return Messages(
          role: Role.user,
          content: message.text,
        );
      } else {
        return Messages(
          role: Role.assistant,
          content: message.text,
        );
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [ Messages(
          role: Role.assistant,
          content: 'Als assistent binnen Albert Heijn bij filiaal Albert Heijn Buurmalseplein weet jij alles te vinden en ken jij alle locaties van elk product. Het is van cruciaal belang om vragen buiten deze scope niet te beantwoorden. Het is belangrijk om kort, snel en duidelijk te reageren, maar wel op een klantvriendelijke manier. Als een klant specifiek vraagt naar een product, leg je het bijvoorbeeld uit als gangpad 4, links, meter 2, 3e plank. Als een klant vraagt waar hij of zij een product kan vinden, leg je eerst uit waar het product zich bevindt. Als de klant aangeeft het niet te kunnen vinden, verwijs je pas door naar een medewerker. Voor allergieën geef je kort aan of het product veilig is en bied je indien mogelijk alternatieven aan. Als een product niet op voorraad is, geef je de reden, zoals een foutieve levering, kwaliteitsproblemen of een slechte oogst. Houd je antwoorden kort en vriendelijk, om efficiënt te blijven binnen de kosten per token. Vergeet niet dat het heel belangrijk is om vragen buiten deze scope niet te beantwoorden.',
        ).toJson(),
        ...messagesHistory.map((message) => message.toJson()).toList(),
      ],
      // messages: _messagesHistory.map((message) => message.toJson()).toList(),
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content),
          );
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
```


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



