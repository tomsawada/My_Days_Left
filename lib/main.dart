//IMPORT MATERIAL PACKAGES
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//IMPORT SCREENS
import 'package:days_left/screens/days_left.dart';
import 'package:days_left/screens/myself_input.dart';
import 'package:days_left/screens/health_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String deathDateLocal;

  @override
  void initState(){
    super.initState();
    checkHasData();
  }

  checkHasData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deathDateLocal = prefs.get("deathDateLocal");
    return deathDateLocal;
  }

  @override
  Widget build(BuildContext context) {
    print(deathDateLocal);
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: Color(0xFFECEFF1), //Colors.blueGrey[50]
          trackHeight: 1,
          thumbColor: Color(0xFFa4c2f4),
          overlayColor: Color(0x29a4c2f4),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        ),
      ),
      //TODO: FutureBuilder Here
      home: deathDateLocal == null ? MyselfInput() : DaysLeft(),
    );
  }
}
