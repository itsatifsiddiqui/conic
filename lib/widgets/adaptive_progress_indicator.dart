import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/res.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (Platform.isIOS)
          const CupertinoActivityIndicator()
        else
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        const SizedBox(height: 16),
        Text(
          'Please Wait',
          style: TextStyle(
            color: Theme.of(context).dividerColor.withOpacity(0.60),
            fontSize: 16.sp,
          ),
        ),
      ],
    ));
  }
}
