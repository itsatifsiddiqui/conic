import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import 'res/res.dart';
import 'screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          canvasColor: const Color(0xff1F1F1F),
          scaffoldBackgroundColor: const Color(0xFF1F1F1F),
          primaryColor: AppColors.primaryColor,
          accentColor: AppColors.primaryColor,
          brightness: Brightness.dark,
          dividerColor: Colors.white,
          fontFamily: 'montserrat',
          hoverColor: Colors.black,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primaryColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        theme: ThemeData(
          canvasColor: const Color(0xffF6F8FB),
          scaffoldBackgroundColor: const Color(0xFFF6F8FB),
          accentColor: AppColors.primaryColor,
          primaryColor: AppColors.primaryColor,
          dividerColor: Colors.black,
          hoverColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primaryColor,
          ),
          fontFamily: 'montserrat',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        builder: (context, child) {
          return _Unfocus(child: child!);
        },
        home: const SplashScreen(),
      ),
    );
  }
}

class _Unfocus extends StatelessWidget {
  const _Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
