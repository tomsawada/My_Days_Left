//IMPORT MATERIAL PACKAGES
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//IMPORT SCREENS
import 'days_left.dart';
//IMPORT UI ELEMENTS
import 'package:days_left/ui_elements/material_elements.dart';
import 'package:days_left/ui_elements/cupertino_elements.dart';
import 'package:days_left/ui_elements/android_elements.dart';
import 'package:days_left/ui_elements/constants.dart';

class HabitsInput extends StatefulWidget {
  final double lifeExpectancyAfterHealth;
  final double days;

  const HabitsInput({Key key, this.lifeExpectancyAfterHealth, this.days})
      : super(key: key);

  @override
  _HabitsInputState createState() => _HabitsInputState(
      lifeExpectancyAfterHealth: this.lifeExpectancyAfterHealth,
      days: this.days);
}

class _HabitsInputState extends State<HabitsInput> {
  double lifeExpectancyAfterHealth;
  double days;
  _HabitsInputState({this.lifeExpectancyAfterHealth, this.days});
  int exercise = 3;
  int drink = 2;
  int smoke = 20;

  exerciseLifeCalculator() {
    return (((exercise * 2 * 52) / 24) * lifeExpectancyAfterHealth) / 365.25;
  }

  smokeLifeCalculator() {
    return ((smoke * (-12) * 336) * lifeExpectancyAfterHealth) / 525600;
  }

  double drinkLifeCalculator() {
    if (drink == 0) {
      return 0;
    } else if (drink <= 2) {
      return 1.15;
    } else if (drink <= 4) {
      return 0;
    } else if (drink <= 7) {
      return 0.9;
    } else {
      return 0.8;
    }
  }

  calculateLifeExpectancyAfterHabits() {
    return (lifeExpectancyAfterHealth +
            exerciseLifeCalculator() +
            smokeLifeCalculator()) *
        drinkLifeCalculator();
  }

  saveLocalDaysData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('daysLocal', days);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About my habits 3/3',
          style: kTitleStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'I EXERCISE',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        exercise.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        ' hours a week',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  Slider(
                      value: exercise.toDouble(),
                      min: 0,
                      max: 20,
                      onChanged: (double newValue) {
                        setState(() {
                          exercise = newValue.round();
                        });
                      }),
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
                    'I DRINK',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        drink.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        ' alcoholic drinks a day',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  Slider(
                      value: drink.toDouble(),
                      min: 0,
                      max: 10,
                      onChanged: (double newValue) {
                        setState(() {
                          drink = newValue.round();
                        });
                      }),
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
                    'I SMOKE',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        smoke.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        ' cigarettes a day',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  Slider(
                      value: smoke.toDouble(),
                      min: 0,
                      max: 60,
                      onChanged: (double newValue) {
                        setState(() {
                          smoke = newValue.round();
                        });
                      }),
                ],
              ),
            ),
          ),
          BottomButton(
            buttonTitle: 'CALCULATE',
            onTap: () {
              exerciseLifeCalculator();
              smokeLifeCalculator();
              drinkLifeCalculator();
              calculateLifeExpectancyAfterHabits();

              double lifeExpectancyAfterHabits =
                  calculateLifeExpectancyAfterHabits();
              int remainingDays = (lifeExpectancyAfterHabits * 365.35).toInt();
              DateTime deathDate =
                  DateTime.now().add(Duration(days: remainingDays));

              saveLocalDaysData();

              // Print validations
              print('I have been alive $days days');
              print('This is deathDate $deathDate');
              print('This is deathDate to Iso ${deathDate.toIso8601String()}');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DaysLeft(
                      days: days,
                      deathDate: deathDate,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
