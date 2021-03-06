import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import 'res/res.dart';
import 'screens/splash/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final deepLink = dynamicLink?.link;
      // ignore: unnecessary_string_interpolations
      log('${deepLink?.path}', name: 'ONLINK');
    }, onError: (e) async {
      log(e.message ?? '', name: 'onLinkError');
      log(e.code, name: 'onLinkError');
    });

    final pendingData = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = pendingData?.link;
    // ignore: unnecessary_string_interpolations
    log('${deepLink?.path}', name: 'ONLINK');
  }

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
          indicatorColor: AppColors.primaryColor,
          tabBarTheme: const TabBarTheme(
            unselectedLabelColor: Colors.white54,
            labelColor: AppColors.primaryColor,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
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
          indicatorColor: AppColors.primaryColor,
          tabBarTheme: const TabBarTheme(
            unselectedLabelColor: Colors.black54,
            labelColor: AppColors.primaryColor,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
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
