import 'package:flutter/material.dart';

import '../res/constants.dart';
import '../res/res.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.enabled = true,
    this.isOutline = false,
    required this.text,
    required this.onTap,
    this.elevation = 0,
    this.verticalPadding = 16,
    this.width,
    this.child,
    this.color,
  }) : super(key: key);
  
  final bool enabled;
  final bool isOutline;
  final String text;
  final GestureTapCallback onTap;
  final double elevation;
  final double? width;
  final double verticalPadding;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      highlightElevation: elevation,
      disabledColor: Colors.black54,
      minWidth: width ?? double.infinity,
      color: color ?? (isOutline ? Colors.transparent : AppColors.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        // side: BorderSide(
        //   color: color ?? (!enabled ? Colors.black54 : Colors.transparent),
        //   width: enabled ? 1.5 : 0,
        // ),
      ),
      onPressed: enabled ? onTap : null,
      child: child ??
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
              text,
              style: TextStyle(
                color: !enabled ? context.canvasColor : Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ),
    );
  }
}
