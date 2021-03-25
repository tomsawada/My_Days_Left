import 'package:flutter/material.dart';

class AndroidScreenAlert extends StatelessWidget {
  AndroidScreenAlert({@required this.alertTitle, @required this.alertContent});

  final String alertTitle;
  final String alertContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(alertTitle),
      content: Text(alertContent),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK')),
      ],
    );
  }
}
