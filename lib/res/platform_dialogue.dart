import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showPlatformDialogue({
  required String title,
  Widget? content,
  String? action1Text,
  bool? action1OnTap,
  String? action2Text,
  bool? action2OnTap,
}) async {
  return Get.dialog<bool>(
    (Platform.isAndroid)
        ? AlertDialog(
            title: Text(title),
            content: content,
            actions: <Widget>[
              if (action2Text != null && action2OnTap != null)
                TextButton(
                  onPressed: () => Get.back(result: action2OnTap),
                  child: Text(action2Text),
                ),
              TextButton(
                onPressed: () => Get.back(result: action1OnTap),
                child: Text(action1Text ?? 'OK'),
              ),
            ],
          )
        : CupertinoAlertDialog(
            content: content,
            title: Text(title),
            actions: <Widget>[
              if (action2Text != null && action2OnTap != null)
                CupertinoDialogAction(
                  onPressed: () => Get.back(result: action2OnTap),
                  child: Text(action2Text),
                ),
              CupertinoDialogAction(
                onPressed: () => Get.back(result: action1OnTap),
                child: Text(action1Text ?? 'OK'),
              ),
            ],
          ),
  );
}
