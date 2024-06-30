import 'package:flutter/material.dart';
import 'price_screen.dart';
// import 'screen2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  get selectedCurrency => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: PriceScreen()
      // PriceScreen()
      // ,
    );
  }
}