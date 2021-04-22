import 'package:days_left/screens/myself_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoScreenDialog extends StatelessWidget {
  CupertinoScreenDialog(
      {@required this.alertTitle, @required this.alertContent});

  final String alertTitle;
  final String alertContent;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(alertTitle),
      ),
      content: Text(alertContent),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class CupertinoRecalculate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
              return MyselfInput();
            },
            ),
            );

          },
          child: Text('Recalculate'),
          isDestructiveAction: true,
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
