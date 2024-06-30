import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'consts.dart';
import 'methods.dart';

class DisplayCalcVal extends StatelessWidget {
  final double convertedValue;
  final String selectedCurrency;

  DisplayCalcVal({
    required this.convertedValue,
    required this.selectedCurrency,
  });

  @override
  Widget build(BuildContext context) {
    bool isLandscape2 = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xchango 🤑',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              letterSpacing: 3.0,
              fontStyle: FontStyle.italic,
              fontSize: 35,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                c1,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: bgImgDecoration(),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: isLandscape2
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Converted Value:',
                      style: GoogleFonts.poppins(
                        textStyle: greenContainerTextStyle()
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${convertedValue.toStringAsFixed(3)} $selectedCurrency',
                      style: GoogleFonts.poppins(
                        textStyle: greenContainerTextStyle().copyWith(fontSize: 70),
                      ),textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Converted Value:',
                    style: GoogleFonts.poppins(
                      textStyle: greenContainerTextStyle().copyWith(fontSize: 25,color: c5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${convertedValue.toStringAsFixed(3)} $selectedCurrency',
                      style: GoogleFonts.poppins(
                        textStyle: greenContainerTextStyle().copyWith(fontSize: 70,color: c6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
