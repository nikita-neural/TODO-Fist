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
      ),
      home: const HomePage(title: 'TODO List'),
    );
  }
}
