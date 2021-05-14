import 'package:flutter/material.dart';

import '../../res/res.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_widgets.dart';
import '../tabs_view/tabs_view.dart';

class ActivateNfcScreen extends StatelessWidget {
  const ActivateNfcScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.heightBox,
            const AuthHeader(
              title: 'Let’s Activate',
              subtitle:
                  'Please put the nfc tag above the nfc scanner at the back of your phone to activate.',
            ).pOnly(right: 0.17.sw),
            Image.asset(Images.onBoarding1).centered().expand(),
            8.heightBox,
            PrimaryButton(
              text: 'Tap here to activate',
              onTap: () => Get.offAll<void>(() => const TabsView()),
            ),
            12.heightBox,
            PrimaryButton(
              isOutline: true,
              text: 'Skip for now',
              onTap: () => Get.offAll<void>(() => const TabsView()),
            )
          ],
        ).p16(),
      ),
    );
  }
}
