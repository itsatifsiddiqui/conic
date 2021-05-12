import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../res/res.dart';
import '../auth/login_screen.dart';

final onBoardingProvider = StateProvider<int>((ref) => 0);

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _Header().expand(flex: 2),
            PageView(
              onPageChanged: (value) {
                context.read(onBoardingProvider).state = value;
                if (value == 4) {
                  Get.offAll<void>(() => const LoginScreen());
                  context.read(onBoardingProvider).state = 0;
                }
              },
              children: const [
                _OnBoardItem(
                  heading: 'Activate your conic.',
                  image: Images.onBoarding1,
                  text:
                      'Tap your nfc chip to back of your phone to make it conic.',
                ),
                _OnBoardItem(
                  heading: 'Conic Focused',
                  image: Images.onBoarding2,
                  text:
                      'Mark an account as focused to only share specific account directly.',
                ),
                _OnBoardItem(
                  heading: 'Create Personal Cards',
                  image: Images.onBoarding3,
                  text:
                      'Create multiple cards to share only the information you want to share based on different situations.',
                ),
                _OnBoardItem(
                  heading: 'Insights to analytics',
                  image: Images.onBoarding4,
                  text:
                      'View your stats and streaks all at one place. You can view overall and indivudual account stats.',
                ),
                SizedBox(),
              ],
            ).expand(flex: 18),
            const _Footer().expand(flex: 3),
          ],
        ).px16(),
      ),
    );
  }
}

class _OnBoardItem extends StatelessWidget {
  const _OnBoardItem({
    Key? key,
    required this.heading,
    required this.text,
    required this.image,
  }) : super(key: key);

  final String heading;
  final String text;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.heightBox,
        heading.text.xl.semiBold.makeCentered(),
        24.heightBox,
        Image.asset(image).expand(),
        24.heightBox,
        text.text.center.size(18.sp).make().px24(),
        12.heightBox,
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        24.heightBox,
        'Get Started With Conic'
            .text
            .color(context.adaptive87)
            .xl
            .medium
            .makeCentered(),
      ],
    );
  }
}

class _Footer extends HookWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = useProvider(onBoardingProvider).state;
    return Column(
      children: [
        12.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return AnimatedContainer(
              width: index == i ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              duration: 500.milliseconds,
              decoration: BoxDecoration(
                color: index == i ? context.primaryColor : context.adaptive26,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
        8.heightBox,
        InkWell(
          onTap: () {
            Get.offAll<void>(() => const LoginScreen());
          },
          child: Container(
            child: (index == 3 ? 'Get Started' : 'Skip')
                .text
                .xl
                .medium
                .color(AppColors.primaryColor)
                .makeCentered(),
          ),
        ).expand(),
      ],
    );
  }
}
