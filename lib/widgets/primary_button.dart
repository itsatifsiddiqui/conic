import 'package:flutter/material.dart';

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
      disabledColor: context.adaptive26,
      minWidth: width ?? double.infinity,
      color: color ?? (isOutline ? Colors.transparent : context.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: isOutline ? context.primaryColor : Colors.transparent,
          width: isOutline ? 2 : 0,
        ),
      ),
      onPressed: enabled ? onTap : null,
      child: child ??
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
              text,
              style: TextStyle(
                color: !enabled
                    ? context.canvasColor
                    : isOutline
                        ? context.primaryColor
                        : Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ),
    );
  }
}
