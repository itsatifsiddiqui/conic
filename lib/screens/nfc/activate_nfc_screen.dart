import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/app_user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../res/res.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_widgets.dart';
import '../tabs_view/tabs_view.dart';
import 'tag_reader.dart';
import 'tag_writer.dart';

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
              onTap: () async {
                final completer = Completer<String>();
                await readNfcTag(
                  context: context,
                  handleTag: (tag) async {
                    final link = context.read(appUserProvider)!.link!;
                    final uri = Uri.parse(link);
                    final result = (await writeTag(tag, uri)) ?? '';
                    completer.complete(result);
                    return result;
                  },
                );
                final result = await completer.future;
                if (result == 'Success') {
                  log('WRITE SUCCESS');
                  // ignore: unawaited_futures
                  context.read(authProvider).navigateBasedOnCondition();
                }
              },
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
