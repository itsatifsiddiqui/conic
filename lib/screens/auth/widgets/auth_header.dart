import 'package:flutter/material.dart';

import '../../../res/res.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: title.text.xl5.bold.heightTight
              .color(context.primaryColor)
              .make(),
        ),
        12.heightBox,
        subtitle.text.lg.color(context.adaptive75).make(),
        16.heightBox,
      ],
    );
  }
}
