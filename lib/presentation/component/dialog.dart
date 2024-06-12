import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String result,
  bool doublePop = false,
}) =>
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(result),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              if (doublePop) Navigator.pop(context);
            },
            child: const Text('확인', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
