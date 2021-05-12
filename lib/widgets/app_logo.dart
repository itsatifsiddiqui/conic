import 'package:flutter/material.dart';

import '../res/res.dart';

class AppLogo extends StatelessWidget {
  const AppLogo.white({Key? key, this.black = false}) : super(key: key);

  const AppLogo.black({Key? key, this.black = true}) : super(key: key);

  final bool black;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Image.asset(
        getImage(context),
        height: 0.25.sh,
        width: 0.6.sw,
      ).centered(),
    );
  }

  String getImage(BuildContext context) {
    return black ? Images.logoBlack : Images.logoWhite;
  }
}
