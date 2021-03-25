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
            // TODO: Erase the calculations and get back to the beginning.
            // Here goes the recalculation /**/
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
