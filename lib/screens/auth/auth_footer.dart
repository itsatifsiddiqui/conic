import 'package:flutter/material.dart';

import '../../res/res.dart';
import 'signup_screen.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter.login({Key? key, this.isSignup = false}) : super(key: key);
  const AuthFooter.signup({Key? key, this.isSignup = true}) : super(key: key);

  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.heightBox,
        'OR Login With'
            .text
            .lg
            .semiBold
            .color(context.primaryColor)
            .makeCentered(),
        32.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(kBorderRadius),
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  Images.google,
                  width: 64,
                  height: 64,
                ),
              ),
            ),
            20.widthBox,
            ClipRRect(
              borderRadius: BorderRadius.circular(kBorderRadius),
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  Images.facebook,
                  width: 64,
                  height: 64,
                ),
              ),
            ),
            20.widthBox,
            ClipRRect(
              borderRadius: BorderRadius.circular(
                kBorderRadius,
              ),
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  Images.apple,
                  width: 64,
                  height: 64,
                ).scale(scaleValue: 1.2),
              ),
            ),
          ],
        ),
        20.heightBox,
        (isSignup ? 'Already Have an account? ' : 'Do not have an account? ')
            .richText
            .lg
            .color(context.adaptive70)
            .withTextSpanChildren([
              (isSignup ? 'Login' : 'Sign-up')
                  .textSpan
                  .color(context.primaryColor)
                  .bold
                  .make(),
            ])
            .makeCentered()
            .py8()
            .mdClick(() {
              if (isSignup) {
                Get.back<void>();
              } else {
                Get.to<void>(() => const SignupScreen());
              }
            })
            .make()
      ],
    );
  }
}
