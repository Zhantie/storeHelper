import 'package:fitness/screens/chat_screen.dart';
import 'package:fitness/screens/home_screen.dart';
import 'package:fitness/screens/location_screen.dart';
import 'package:fitness/screens/recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    // Set the navigation color for android devices.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF00B295),
        systemNavigationBarDividerColor: Color(0xFF00B295),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          primary: Color(0xFF00B295),
          secondary: Color(0xFF2B2D42),
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            fontSize: 10.0,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      routes: {
        // '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/recepten': (context) => const RecipeScreen(),
        '/location': (context) => const LocationProductScreen(),
        '/chat': (context) => const ChatScreen(),
      },
      initialRoute: '/home',
    );
  }
}
