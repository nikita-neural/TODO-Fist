import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list_app/views/HomePage.dart';
import 'package:list_app/shared/CustomColors.dart';
import 'package:list_app/viewmodels/ItemListViewModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ItemListViewModel(),
      child: MaterialApp(
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
      ),
    );
  }
}
