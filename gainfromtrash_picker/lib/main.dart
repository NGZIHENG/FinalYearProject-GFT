import 'package:flutter/material.dart';
import 'splachscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gain From Trash',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          Colors.green[100]!.value,
          <int, Color>{
            50: Colors.green[50]!,
            100: Colors.green[100]!,
            200: Colors.green[200]!,
            300: Colors.green[300]!,
            400: Colors.green[400]!,
            500: Colors.green[500]!,
            600: Colors.green[600]!,
            700: Colors.green[700]!,
            800: Colors.green[800]!,
            900: Colors.green[900]!,
          },
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        )
      ),
      home: const SplashScreen(),
      );
  }
}