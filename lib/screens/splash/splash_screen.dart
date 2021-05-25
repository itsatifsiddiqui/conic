import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../res/res.dart';
import '../add_account/add_new_account_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read(authProvider).checkAppleSignIn();
    context.read(allAccountsProvider).data;
    Timer(1.seconds, context.read(authProvider).navigateBasedOnCondition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.1, end: 1),
        curve: Curves.easeInOutQuart,
        duration: 0.8.seconds,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: 'Conic'.text.xl6.bold.color(context.adaptive).widest.make().centered(),
      ),
    );
  }
}
