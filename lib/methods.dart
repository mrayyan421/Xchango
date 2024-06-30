import 'package:flutter/material.dart';
import 'consts.dart';
import 'coin_data.dart';

class topCard extends StatelessWidget {
  const topCard({
    super.key,
    required this.isLoading,
    required this.selectedCurrency1,
    required this.selectedCurrency2,
    required this.exRateRequired,
  });

  final bool isLoading;
  final String selectedCurrency1;
  final String selectedCurrency2;
  final double exRateRequired;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: c1,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          isLoading
              ? 'Loading...'
              : '1 $selectedCurrency1 = ${exRateRequired.toStringAsFixed(3)} $selectedCurrency2',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ConversionData {
  final double conversionRate;
  final String rateTime1;
  final String rateTime2;

  ConversionData({required this.conversionRate, required this.rateTime1,required this.rateTime2});
}



