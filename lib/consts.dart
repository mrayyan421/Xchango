
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

Color c1 = Color(0xFFB9770E);
Color c2 = Color(0xFFF39C12);
Color c3 = Color(0xFF0E6251);
Color c4 = Color(0xFFF8C8DC);
Color c5= Color(0xFF784212);
Color c6 = Color(0xFF117864);
double br = 10.0;

bool isLoading = true;
String selectedCurrency1 = 'USD';
String selectedCurrency2 = 'PKR';
double convertToSelectedCurrency = 0.0;
int enteredValue = 0;
double convertedValue = 0.0;
TextEditingController controller = TextEditingController();
double toUsdRate1 = 0;
double btcToSelectedCurrencyRate = 0;
String t1 = "Fri, 28 Jun 2024 00:00:02 +0000";
String t2 = "Fri, 28 Jun 2024 00:00:02 +0000";

BoxDecoration bgImgDecoration() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/bgImg.png'),
      fit: BoxFit.fill,
    ),
  );
}

TextStyle smallTextStyle() {
  return TextStyle(
      fontSize: 16, fontWeight: FontWeight.w800, color: c2);
}


TextStyle greenContainerTextStyle() => TextStyle(color: c2,fontSize: 25, fontWeight: FontWeight.w700);