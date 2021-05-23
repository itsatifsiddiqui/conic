import 'package:flutter/material.dart';

import '../res/res.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    Key? key,
    required this.text,
    this.subText,
    this.onTryAgain,
    this.tryAgainText,
  }) : super(key: key);

  final String text;
  final String? subText;
  final GestureTapCallback? onTryAgain;
  final String? tryAgainText;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 75.sp,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).dividerColor.withOpacity(0.54),
                fontSize: 22.sp,
              ),
            ),
            const SizedBox(height: 12),
            if (subText != null)
              Text(
                subText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).dividerColor.withOpacity(0.54),
                  fontSize: 16.sp,
                ),
              ),
            24.heightBox,
            if (onTryAgain != null)
              TextButton(
                onPressed: onTryAgain,
                child: Text(
                  tryAgainText ?? 'Try Again',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24.sp,
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
