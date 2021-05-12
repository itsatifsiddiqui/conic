import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xffD32F2F);
  static const Color accentColor = Color(0xffD32F2F);
  static const Color teal = Color(0xff03D4BF);
  static const Color facebookBlue = Color(0xff547AAD);
  static const Color googleOrange = Color(0xfff44336);
  static const Color orange = Color(0xffFF9F00);
  static const Color lightGrey = Color(0xffeeeeee);

  static LinearGradient dashboardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff6DAEFC),
      Color(0xff3677FC),
    ],
  );
  static LinearGradient myDevicesGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff8549D7),
      Color(0xff4E5BC8),
    ],
  );
  static LinearGradient nearbyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffE979A0),
      Color(0xffEB4D6C),
    ],
  );
  static LinearGradient helpGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff49D76F),
      Color(0xff1F89BE),
    ],
  );
}
