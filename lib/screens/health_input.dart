//IMPORT MATERIAL PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//IMPORT SCREENS
import 'package:days_left/screens/myself_input.dart';
import 'package:days_left/screens/habits_input.dart';
//IMPORT DATA
import '../data/bmi_calculation.dart';
import 'package:days_left/data/diabetes_table.dart';
//IMPORT UI ELEMENTS
import 'package:days_left/ui_elements/material_elements.dart';
import 'package:days_left/ui_elements/cupertino_elements.dart';
import 'package:days_left/ui_elements/android_elements.dart';
import 'package:days_left/ui_elements/constants.dart';

enum Diabetes {
  diabetic,
  notDiabetic,
}

class HealthInput extends StatefulWidget {
  final double baseLifeExpectancy;
  final Gender selectedGender;
  final double days;
  const HealthInput(
      {Key key, this.baseLifeExpectancy, this.selectedGender, this.days})
      : super(key: key);

  @override
  _HealthInputState createState() => _HealthInputState(
      baseLifeExpectancy: this.baseLifeExpectancy,
      selectedGender: this.selectedGender,
      days: this.days);
}

class _HealthInputState extends State<HealthInput> {
  double baseLifeExpectancy;
  Gender selectedGender;
  double days;
  _HealthInputState({this.baseLifeExpectancy, this.selectedGender, this.days});
  Color diabeticCardColour = kInactiveCardColour;
  Color notDiabeticCardColour = kInactiveCardColour;
  Diabetes selectedDiabetes;
  final double radius = 60;
  double _movement = 0;
  double _movements = 0;
  int weightLbs = 100;
  int weightKg = 60;
  int heightFt = 50;
  int heightCm = 180;
  bool switchMetric = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About my health 2/3',
          style: kTitleStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 19, right: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Text(
                  'Metric',
                  style: kLabelTextStyle,
                ),
                SizedBox(
                  width: 15,
                ),
                Platform.isIOS
                    ? CupertinoSwitch(
                        value: switchMetric,
                        onChanged: (bool value) {
                          setState(() {
                            switchMetric = value;
                          });
                        })
                    : Switch(
                        value: switchMetric,
                        onChanged: (bool value) {
                          setState(() {
                            switchMetric = value;
                          });
                        }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WEIGHT',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          switchMetric
                              ? weightKg.abs().toString()
                              : weightLbs.abs().toString(),
                          style: kNumberTextStyle,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onPanUpdate: _panHandler,
                              child: Transform.rotate(
                                angle: _movement,
                                child: Container(
                                  height: radius * 2,
                                  width: radius * 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('images/dashed.PNG'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF37474F),
                              ),
                              child: Center(
                                child: Text(
                                  switchMetric ? 'kg' : 'lbs',
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        Text('HEIGHT', style: kLabelTextStyle),
                        Text(
                            switchMetric
                                ? heightCm.abs().toString()
                                : (heightFt / 10).abs().toString(),
                            style: kNumberTextStyle),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onPanUpdate: _panHandler2,
                              child: Transform.rotate(
                                angle: _movements,
                                child: Container(
                                  height: radius * 2,
                                  width: radius * 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('images/dashed.PNG'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF37474F),
                              ),
                              child: Center(
                                child: Text(
                                  switchMetric ? 'cm' : 'ft',
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedDiabetes = Diabetes.notDiabetic;
                      });
                    },
                    colour: selectedDiabetes == Diabetes.notDiabetic
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.timesCircle,
                      label: 'NOT DIABETIC',
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedDiabetes = Diabetes.diabetic;
                      });
                    },
                    colour: selectedDiabetes == Diabetes.diabetic
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: IconContent(
                        icon: FontAwesomeIcons.circle, label: 'DIABETIC'),
                  ),
                ),
              ],
            ),
          ),
          BottomButton(
            buttonTitle: 'NEXT',
            onTap: () {
              // Making Diabetes mandatory
              if (selectedDiabetes == null) {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return Platform.isIOS
                          ? CupertinoScreenDialog(
                              alertTitle: 'Are you diabetic?',
                              alertContent:
                                  'Please insert if you\'re diabetic or not',
                            )
                          : AndroidScreenAlert(
                              alertTitle: 'Are you diabetic?',
                              alertContent:
                                  'Please insert if you\'re diabetic or not',
                            );
                    });
              } else {
                BmiCalculation calc = BmiCalculation(
                    height: switchMetric ? heightCm : heightFt,
                    weight: switchMetric ? weightKg : weightLbs);

                switchMetric
                    ? calc.calculateBmiMetric()
                    : calc.calculateBmiImperial();

                double calculateLifeExpectancyAfterHealth() {
                  if (selectedGender == Gender.male &&
                      selectedDiabetes == Diabetes.diabetic) {
                    return (baseLifeExpectancy +
                        calc.resultMaleBMI() +
                        maleDiabetesType2[(((days / 365.25) / 5).ceil()) * 5]);
                  } else if (selectedGender == Gender.female &&
                      selectedDiabetes == Diabetes.diabetic) {
                    return (baseLifeExpectancy +
                        calc.resultFemaleBMI() +
                        femaleDiabetesType2[
                            (((days / 365.25) / 5).ceil()) * 5]);
                  } else if (selectedGender == Gender.male &&
                      selectedDiabetes == Diabetes.notDiabetic) {
                    return (baseLifeExpectancy + calc.resultMaleBMI());
                  } else if (selectedGender == Gender.female &&
                      selectedDiabetes == Diabetes.notDiabetic) {
                    return (baseLifeExpectancy + calc.resultFemaleBMI());
                  }
                }

                double lifeExpectancyAfterHealth =
                    calculateLifeExpectancyAfterHealth();

                //Print Validations
                print('I am $selectedDiabetes');
                print(
                    'I am expected to live another $baseLifeExpectancy years');
                print('My gender is $selectedGender');

                print(
                    'My BMI is ${switchMetric ? calc.calculateBmiMetric() : calc.calculateBmiImperial()}');
                print(
                    'My BMI result is giving me ${calc.resultMaleBMI()} years');
                print(
                    'My lifeExpectancyAfterHealth is now $lifeExpectancyAfterHealth');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HabitsInput(
                        lifeExpectancyAfterHealth: lifeExpectancyAfterHealth,
                        days: days,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange * -1
        : yChange;

    double horz =
        (onTop && panLeft) || (onBottom && panRight) ? xChange * -1 : xChange;

    // Total computed change with velocity
    double rotationalChange = vert + horz * (d.delta.distance * 0.2);

    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;

    setState(() {
      _movement = rotationalChange;
      _movement > 0
          ? switchMetric
              ? weightKg++
              : weightLbs++
          : switchMetric
              ? weightKg--
              : weightLbs--;
    });
  }

  void _panHandler2(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange * -1
        : yChange;

    double horz =
        (onTop && panLeft) || (onBottom && panRight) ? xChange * -1 : xChange;

    // Total computed change with velocity
    double rotationalChange = vert + horz * (d.delta.distance * 0.2);

    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;

    setState(() {
      _movements = rotationalChange;
      _movements > 0
          ? switchMetric
              ? heightCm++
              : heightFt++
          : switchMetric
              ? heightCm--
              : heightFt--;
    });
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: <Widget>[
//     RoundIconButton(
//       icon: FontAwesomeIcons.minus,
//       onPressed: () {
//         setState(() {
//           weight--;
//         });
//       },
//     ),
//     SizedBox(width: 10.0),
//     RoundIconButton(
//       icon: FontAwesomeIcons.plus,
//       onPressed: () {
//         setState(() {
//           weight++;
//         });
//       },
//     ),
//   ],
// ),

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: <Widget>[
//     RoundIconButton(
//         icon: FontAwesomeIcons.minus,
//         onPressed: () {
//           setState(() {
//             height--;
//           });
//         }),
//     SizedBox(width: 10.0),
//     RoundIconButton(
//         icon: FontAwesomeIcons.plus,
//         onPressed: () {
//           setState(() {
//             height++;
//           });
//         })
//   ],
// ),
