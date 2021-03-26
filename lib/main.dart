//IMPORT MATERIAL PACKAGES
import 'package:flutter/material.dart';
//IMPORT SCREENS
import 'package:days_left/screens/days_left.dart';
import 'package:days_left/screens/myself_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: MyselfInput(),
    );
  }
}
