//IMPORT MATERIAL PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
//TODO: deathDateLocal must be parse to continue with the calculation
// And if the user closes the app and then re-opens, the calculation must be able to continue running.

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

  double daysLocal;
  String deathDateLocal;
  int _daysLeft;
  Timer _everysecond;


  saveLocalDeathDateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deathDateLocal', deathDate.toIso8601String());
  }



  readAllLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    daysLocal = prefs.getDouble('daysLocal');
    print('I am in daysLeft and the locally saved is days $daysLocal');
    deathDateLocal = prefs.getString('deathDateLocal');
    print(
        'I am in daysLeft and the locally saved deathDate is $deathDateLocal');

  }

  deleteLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('daysLocal');
    prefs.remove('deathDateLocal');
  }

  //https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html

  @override
  void initState() {
    saveLocalDeathDateData();
    readAllLocalData();
    print('This is the parsing ${DateTime.parse(deathDateLocal ?? deathDate.toIso8601String()).difference(DateTime.now()).inDays.toInt()}');
    _daysLeft = DateTime.parse(deathDateLocal ?? deathDate.toIso8601String()).difference(DateTime.now()).inDays.toInt();
    // _daysLeft = deathDate.difference(DateTime.now()).inSeconds.toInt();
    print('I am in initState and _daysLeft is $_daysLeft');
    _everysecond = Timer.periodic(Duration(hours: 1), (Timer t) {
      setState(() {
        _daysLeft = DateTime.parse(deathDateLocal).difference(DateTime.now()).inDays.toInt();
        // _daysLeft = deathDate.difference(DateTime.now()).inDays.toInt();

      });
    });
    super.initState();
  }

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
                    print(DateTime.parse(deathDateLocal));
                    // deleteLocalData();
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
          percent: (days / (days + _daysLeft)),
          backgroundColor: Colors.transparent,
          progressColor: Color(0xFFa4c2f4),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (f.format(_daysLeft)).toString(),
                style: kDaysCounterTextStyle,
              ),
              Text(
                'Days left',
                style: kDaysLeftTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
