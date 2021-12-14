import 'dart:developer';

import 'package:conic/providers/auth_provider.dart';
import 'package:conic/res/res.dart';
import 'package:conic/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    context.read(authProvider).user.sendEmailVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleStateObserver(
      onresumed: () async {
        log('Check verification status and navigate', name: 'EmailVerificationScreen');
        await context.read(authProvider).user.reload();
        log('RELOADED', name: 'EmailVerificationScreen');

        final emailVerified = context.read(authProvider).user.emailVerified;
        if (emailVerified) {
          await context.read(authProvider).navigateBasedOnCondition();
          VxToast.show(
            context,
            msg: 'Thank you for verifying your email.',
            showTime: 3000,
          );
        } else {
          VxToast.show(
            context,
            msg: 'Please verify your email address.\nIf already verified, click on inbox',
            showTime: 3000,
          );
        }
      },
      child: WillPopScope(
        onWillPop: () {
          context.read(authProvider).signOut();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(),
          body: InkWell(
            onTap: () async {
              print(context.read(authProvider).user.providerData.map((e) => e.providerId).toList());
              log('Check verification status and navigate', name: 'EmailVerificationScreen');
              await context.read(authProvider).user.reload();

              final emailVerified = context.read(authProvider).user.emailVerified;
              if (emailVerified) {
                await context.read(authProvider).navigateBasedOnCondition();
                VxToast.show(
                  context,
                  msg: 'Thank you for verifying your email.',
                  showTime: 3000,
                );
              } else {
                VxToast.show(
                  context,
                  msg: 'Please verify your email address.\nIf already verified, click on inbox',
                  showTime: 3000,
                );
              }
            },
            child: Column(
              children: [
                16.heightBox,
                const AuthHeader(
                  title: 'Verifiy Email',
                  subtitle:
                      'Please check your inbox.\nWe\'ve sent you instructions to verify your email',
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      color: context.primaryColor,
                      size: 150,
                    ),
                    8.heightBox,
                    HookBuilder(builder: (context) {
                      final email = useProvider(authProvider.select((value) => value.user.email));
                      return "Please verify your email \'$email\' to continue."
                          .text
                          .xl
                          .center
                          .medium
                          .color(context.adaptive54)
                          .make();
                    })
                  ],
                ).centered().expand(flex: 2),
                Spacer(),
              ],
            ).px16(),
          ),
        ),
      ),
    );
  }
}

class LifeCycleStateObserver extends StatefulWidget {
  const LifeCycleStateObserver({
    Key? key,
    required this.child,
    this.onresumed,
    this.ondetached,
    this.oninactive,
    this.onpaused,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onresumed;
  final VoidCallback? ondetached;
  final VoidCallback? oninactive;
  final VoidCallback? onpaused;
  @override
  _LifeCycleStateObserverState createState() => _LifeCycleStateObserverState();
}

class _LifeCycleStateObserverState extends State<LifeCycleStateObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.onresumed != null) {
        widget.onresumed?.call();
      }
    }
    if (state == AppLifecycleState.detached) {
      if (widget.ondetached != null) {
        widget.ondetached?.call();
      }
    }
    if (state == AppLifecycleState.inactive) {
      if (widget.oninactive != null) {
        widget.oninactive?.call();
      }
    }
    if (state == AppLifecycleState.paused) {
      if (widget.onpaused != null) {
        widget.onpaused?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
