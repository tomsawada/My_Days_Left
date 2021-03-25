//IMPORT MATERIAL PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
//IMPORT UI ELEMENTS
import 'package:days_left/ui_elements/material_elements.dart';
import 'package:days_left/ui_elements/cupertino_elements.dart';
import 'package:days_left/ui_elements/android_elements.dart';
import 'package:days_left/ui_elements/constants.dart';

//TODO: Make this view the default view until user goes to recalculate
// IF user has certain values, then main.dart should send directly over here. But if user doesn't have certain values,
// then main.dart should send to the start of the process. When user recalculates, all variables are deleted,
// hence applying option 2
//TODO: Remember that the clock must then be re-calculated every day, Hence, the best way to do it is to calculate how
// many days left the user has and set that date in the future as fixed, then substract today(). Then since today()
// should change every day, the user should see the clock coming down daily.
//TODO: see how a clock would work in terms of setState.

enum Option { recalculate }

class DaysLeft extends StatefulWidget {
  final DateTime deathDate;
  final double days;

  const DaysLeft({Key key, this.deathDate, this.days}) : super(key: key);

  @override
  _DaysLeftState createState() =>
      _DaysLeftState(deathDate: this.deathDate, days: this.days);
}

var f = NumberFormat('#,##,000');

class _DaysLeftState extends State<DaysLeft> {
  DateTime deathDate;
  double days;
  _DaysLeftState({this.deathDate, this.days});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF303030),
        elevation: 0,
        actions: <Widget>[
          Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.more_horiz),
                  color: Colors.white,
                  onPressed: () {
                    print(deathDate);
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoRecalculate(),
                    );
                  })
              : PopupMenuButton<Option>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Option>>[
                    const PopupMenuItem<Option>(
                      value: Option.recalculate,
                      child: Text('Recalculate'),
                      // TODO: Erase the calculations and get back to the beginning.
                    ),
                  ],
                ),
        ],
      ),
      body: Center(
        child: CircularPercentIndicator(
          radius: 200.0,
          lineWidth: 4.0,
          percent:
              // (DateTime.now().second) / (60),
              (days /
                  (days +
                      deathDate.difference(DateTime.now()).inDays.toDouble())),
          backgroundColor: Colors.transparent,
          progressColor: Color(0xFFa4c2f4),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                f.format(deathDate.difference(DateTime.now()).inDays.toInt()),
                style: kDaysCounterTextStyle,
              ),
              Text(
                'Days left',
                style: kDaysLeftTextStyle,
              ),
              Text('After Some time ${DateTime.now().second}'),
            ],
          ),
        ),
      ),
    );
  }
}
