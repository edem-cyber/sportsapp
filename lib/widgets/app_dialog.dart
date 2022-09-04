import 'package:flutter/cupertino.dart';

void confirmDialog(BuildContext context, String message, String button1,
    String button2, Function()? button1Tap, Function()? button2Tap) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext ctx) {
      return CupertinoAlertDialog(
        title: const Text('Please Confirm'),
        content: Text(message),
        actions: [
          // The "Yes" button
          CupertinoDialogAction(
            onPressed: button1Tap,
            isDefaultAction: true,
            isDestructiveAction: true,
            child: Text(button1),
          ),
          // The "No" button
          CupertinoDialogAction(
            onPressed: button2Tap,
            isDefaultAction: false,
            isDestructiveAction: false,
            child: Text(button2),
          )
        ],
      );
    },
  );
}
