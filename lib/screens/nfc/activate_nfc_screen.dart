import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:open_settings/open_settings.dart';

import '../../providers/app_user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../res/res.dart';
import '../../widgets/adaptive_progress_indicator.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/error_widet.dart';
import '../../widgets/info_widget.dart';
import '../tabs_view/tabs_view.dart';
import 'tag_reader.dart';
import 'tag_writer.dart';

final isNfcAvailable = FutureProvider.autoDispose<bool>(
  (ref) => NfcManager.instance.isAvailable(),
);

class ActivateNfcScreen extends HookWidget {
  const ActivateNfcScreen({
    Key? key,
    this.showBackButton = false,
  }) : super(key: key);
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return _NfcObserver(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBackButton) const BackButton(),
              if (!showBackButton) 16.heightBox,
              useProvider(isNfcAvailable)
                  .when(
                    data: (isAvailable) {
                      if (!isAvailable) {
                        return const _NotAvailableView();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      ).p16();
                    },
                    loading: () => const AdaptiveProgressIndicator(),
                    error: (e, s) => StreamErrorWidget(
                      error: e.toString(),
                      onTryAgain: () {
                        context.refresh(isNfcAvailable);
                      },
                    ),
                  )
                  .expand(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotAvailableView extends StatelessWidget {
  const _NotAvailableView({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthHeader(
          title: 'NO NFC DETECTED',
          subtitle: 'No worries, you can still use all the features using our qrcode feature.',
        ).pOnly(right: 0.17.sw),
        InfoWidget(
          text: 'NFC Not Availble',
          subText: 'Open the settings and check if nfc is available and enabled!',
          tryAgainText: 'Open Settings',
          onTryAgain: () async {
            await OpenSettings.openNFCSetting();
          },
        ).centered().expand(),
        PrimaryButton(
          isOutline: true,
          text: 'Skip for now',
          onTap: () => Get.offAll<void>(() => const TabsView()),
        )
      ],
    ).p16();
  }
}

class _NfcObserver extends StatefulWidget {
  const _NfcObserver({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _NfcObserverState createState() => _NfcObserverState();
}

// ignore: prefer_mixin
class _NfcObserverState extends State<_NfcObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('didChangeAppLifecycleState');
    debugPrint(state.toString());
    if (state == AppLifecycleState.resumed) {
      context.refresh(isNfcAvailable);
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
