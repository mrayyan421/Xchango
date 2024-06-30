import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'coin_data.dart';
import 'consts.dart';
import 'methods.dart';
import 'screen2.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  late TextEditingController controller;
  late String selectedCurrency1 = currenciesList[0];
  late String selectedCurrency2 = currenciesList[1];
  late double convertToSelectedCurrency = 0.0;
  late bool isLoading = true;
  late String t1 = "";
  late String t2 = "";
  late int enteredValue = 0;
  late double convertedValue = 0.0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _fetchExchangeRate();
  }

  Future<void> _fetchExchangeRate() async {
    try {
      CoinData cd = CoinData();
      ConversionData conversionData =
          await cd.getCoinData(selectedCurrency1, selectedCurrency2);
      setState(() {
        convertToSelectedCurrency = conversionData.conversionRate;
        t1 = conversionData.rateTime1;
        t2 = conversionData.rateTime2;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch exchange rate: $e');
    }
  }

  List<DropdownMenuItem<String>> getAndroidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  DropdownButton<String> getDropdownButton1() {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(10.0),
      value: selectedCurrency1,
      items: getAndroidDropdown(),
      dropdownColor: c2,
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 25),
      ),
      onChanged: (String? value) {
        setState(() {
          selectedCurrency1 = value!;
          isLoading = true;
        });
        _fetchExchangeRate();
      },
    );
  }

  DropdownButton<String> getDropdownButton2() {
    return DropdownButton<String>(
      value: selectedCurrency2,
      items: getAndroidDropdown(),
      dropdownColor: c2,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 25),
      ),
      onChanged: (String? value) {
        setState(() {
          selectedCurrency2 = value!;
          isLoading = true;
        });
        _fetchExchangeRate();
      },
    );
  }

  CupertinoPicker getiOSPicker1() {
    return CupertinoPicker(
      backgroundColor: c1,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency1 = currenciesList[selectedIndex];
          isLoading = true;
        });
        _fetchExchangeRate();
      },
      children: getPickerItems(),
    );
  }

  CupertinoPicker getiOSPicker2() {
    return CupertinoPicker(
      backgroundColor: c1,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency2 = currenciesList[selectedIndex];
          isLoading = true;
        });
        _fetchExchangeRate();
      },
      children: getPickerItems(),
    );
  }

  List<Text> getPickerItems() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return pickerItems;
  }

  void updateEnteredValue() {
    setState(
      () {
        try {
          enteredValue = int.parse(controller.text);
          convertedValue = enteredValue * convertToSelectedCurrency;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayCalcVal(
                convertedValue: convertedValue,
                selectedCurrency: selectedCurrency2,
              ),
            ),
          );
        } catch (e) {
          enteredValue = 0;
          convertedValue = 0.0;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter a valid number'),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context as BuildContext).orientation ==
        Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xchango 🤑',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  letterSpacing: 3.0,
                  fontStyle: FontStyle.italic,
                  fontSize: 35,
                  fontWeight: FontWeight.w800)),
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
            child: isLandscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Today\'s rate',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: c1,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                              fontSize: 50),
                        ),
                      ),
                      Text(
                        'Last Updated: $t1',
                        style: GoogleFonts.poppins(
                          textStyle: smallTextStyle(),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Next Update: $t2',
                        style: GoogleFonts.poppins(
                          textStyle: smallTextStyle(),
                        ),
                      ),
                      Expanded(
                        child: topCard(
                          isLoading: isLoading,
                          selectedCurrency1: selectedCurrency1,
                          selectedCurrency2: selectedCurrency2,
                          exRateRequired: convertToSelectedCurrency,
                        ),
                      ),
                      Container(
                        height: 50.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: TextField(
                          controller: controller,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Enter Value',
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(3.0),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: updateEnteredValue,
                        child: Text('Convert Value'),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            height: 110.0,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 30.0),
                            decoration: BoxDecoration(
                              color: c3,
                              borderRadius: BorderRadius.circular(br),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Text>[
                                      Text(
                                        'From',
                                        style: greenContainerTextStyle(),
                                      ),
                                      Text(
                                        'To',
                                        style: greenContainerTextStyle(),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Platform.isAndroid
                                            ? getDropdownButton1()
                                            : getiOSPicker1(),
                                        Platform.isAndroid
                                            ? getDropdownButton2()
                                            : getiOSPicker2(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                          child: Card(
                            color: c2,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 28.0),
                              child: Text(
                                'Converted Value: ${convertedValue.toStringAsFixed(3)} $selectedCurrency2',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Today\'s rate',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: c1,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                            fontSize: 50,
                          ),
                        ),
                      ),
                      Text(
                        'Last Updated: $t1',
                        style: GoogleFonts.poppins(
                          textStyle: smallTextStyle(),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Next Update: $t2',
                        style: GoogleFonts.poppins(
                          textStyle: smallTextStyle(),
                        ),
                      ),
                      Expanded(
                        child: topCard(
                          isLoading: isLoading,
                          selectedCurrency1: selectedCurrency1,
                          selectedCurrency2: selectedCurrency2,
                          exRateRequired: convertToSelectedCurrency,
                        ),
                      ),
                      Container(
                        height: 50.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: controller,
                          decoration: InputDecoration(labelText: 'Enter Value',alignLabelWithHint: true,contentPadding: EdgeInsets.only(left: 5,right: 5),focusColor: c5, ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: updateEnteredValue,
                        child: Text('Convert Value'),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            height: 110.0,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 30.0),
                            decoration: BoxDecoration(
                              color: c3,
                              borderRadius: BorderRadius.circular(br),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Text>[
                                      Text(
                                        'From',
                                        style: greenContainerTextStyle(),
                                      ),
                                      Text(
                                        'To',
                                        style: greenContainerTextStyle(),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Platform.isAndroid
                                            ? getDropdownButton1()
                                            : getiOSPicker1(),
                                        Platform.isAndroid
                                            ? getDropdownButton2()
                                            : getiOSPicker2(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                          child: Card(
                            color: c2,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 28.0),
                              child: Text(
                                'Converted Value: ${convertedValue.toStringAsFixed(3)} $selectedCurrency2',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

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
      color: c2,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : Text(
                    '1 $selectedCurrency1 = ${exRateRequired.toStringAsFixed(3)} $selectedCurrency2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
