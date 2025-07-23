import 'package:flutter/material.dart';
import 'package:list_app/pages/HomePage.dart';
import 'package:list_app/shared/CustomColors.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            errorColor: Colors.red,
            successColor: Colors.green,
          ),
        ],
        // errorColor and successColor are not standard ThemeData properties.
        // To add custom colors, use extensions or define them in the colorScheme.
        // Example of adding custom colors via extensions:
        // Removed CustomColors extension as it is not defined.
        // If you want to add custom colors, define a ThemeExtension and import it.

      ),
      home: const HomePage(title: 'Item List 1'),
    );
  }
}
