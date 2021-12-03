import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Colors.indigo;
  static const Color accentColor = Color(0xffD32F2F);
  static const Color teal = Color(0xff03D4BF);
  static const Color facebookBlue = Color(0xff547AAD);
  static const Color googleOrange = Color(0xfff44336);
  static const Color orange = Color(0xffFF9F00);
  static const Color lightGrey = Color(0xffeeeeee);
  static const Color link = Color(0xff3D60BF);
  static const Color grey = Color(0xff707070);

  static LinearGradient blueGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff6DAEFC),
      Color(0xff3677FC),
    ],
  );
  static LinearGradient orangeGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffF6B57A),
      Color(0xffF08891),
    ],
  );

  static LinearGradient redGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffE979A0),
      Color(0xffEB4D6C),
    ],
  );
  static LinearGradient lightPurpleGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff9F69F0),
      Color(0xffE35FD5),
    ],
  );

  static LinearGradient purpleGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff8549D7),
      Color(0xff4E5BC8),
    ],
  );
  static LinearGradient greenGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff49D76F),
      Color(0xff1F89BE),
    ],
  );
}
