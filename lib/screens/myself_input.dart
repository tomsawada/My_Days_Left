//IMPORT MATERIAL PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//IMPORT SCREENS
import 'package:days_left/screens/health_input.dart';
//IMPORT DATA
import 'package:days_left/data/country_list.dart';
import 'package:days_left/data/actuary_tables.dart';
//IMPORT UI ELEMENTS
import 'package:days_left/ui_elements/material_elements.dart';
import 'package:days_left/ui_elements/cupertino_elements.dart';
import 'package:days_left/ui_elements/android_elements.dart';
import 'package:days_left/ui_elements/constants.dart';

enum Gender {
  male,
  female,
}

class MyselfInput extends StatefulWidget {
  @override
  _MyselfInputState createState() => _MyselfInputState();
}

class _MyselfInputState extends State<MyselfInput> {
  Color maleCardColour = kInactiveCardColour;
  Color femaleCardColour = kInactiveCardColour;
  Gender selectedGender;
  String selectedCountry = 'USA';

  //Grabbing life expectancy from actuary_tables.dart
  double calculateBaseLifeExpectancy(double days) {
    if (selectedGender == Gender.male && selectedCountry == 'USA') {
      return maleMapUSA[((days / 365.25).floor())];
    } else if (selectedGender == Gender.female && selectedCountry == 'USA') {
      return femaleMapUSA[((days / 365.25).floor())];
    }
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String country in countriesList) {
      var newItem = DropdownMenuItem(
        child: Text(country),
        value: country,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCountry,
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCountry = value;
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String country in countriesList) {
      Text(country);
      pickerItems.add(
        Text(
          country,
          style: TextStyle(color: Colors.blueGrey[50]),
        ),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.transparent,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCountry = countriesList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }

  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About me 1/3',
          style: kTitleStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    colour: selectedGender == Gender.male
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.mars,
                      label: 'MALE',
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                      onPress: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      colour: selectedGender == Gender.female
                          ? kActiveCardColour
                          : kInactiveCardColour,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.venus,
                        label: 'FEMALE',
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'I LIVE IN',
                    style: kLabelTextStyle,
                  ),
                  SizedBox(height: 15),
                  Platform.isIOS ? iOSPicker() : androidDropdown(),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'I WAS BORN ON',
                    style: kLabelTextStyle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                              color: Colors.blueGrey[50], fontSize: 19),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        backgroundColor: Colors.transparent,
                        initialDateTime: now,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (dateTime) {
                          setState(() {
                            now = dateTime;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomButton(
            onTap: () {
              var ageValidation = DateTime.now().difference(now);
              double days = ageValidation.inDays.toDouble();
              double baseLifeExpectancy = calculateBaseLifeExpectancy(days);

              // Making gender and DOB mandatory
              if (selectedGender == null || ageValidation.inDays < 3650) {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return Platform.isIOS
                          ? CupertinoScreenDialog(
                              alertTitle: 'Gender and Date of birth',
                              alertContent:
                                  'Please insert your gender and date of birth. You must be at least 10 years old.',
                            )
                          : AndroidScreenAlert(
                              alertTitle: 'Gender and Date of birth',
                              alertContent:
                                  'Please insert your gender and date of birth. You must be at least 10 years old.',
                            );
                    });
              } else {
                //Print Validations
                // print('Since I was born $days have passed');
                // print('My age is ${days / 365.25}');
                // print(
                //     'I am expected to live another $baseLifeExpectancy years');
                // print('I am a $selectedGender');
                //Going to the next screen

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HealthInput(
                        baseLifeExpectancy: baseLifeExpectancy,
                        selectedGender: selectedGender,
                        days: days,
                      );
                    },
                  ),
                );
              }
            },
            buttonTitle: 'NEXT',
          ),
        ],
      ),
    );
  }
}
