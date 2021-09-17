import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../res/constants.dart';

const _host = 'conic-688fe.web.app';

@immutable
class DynamicLinkGenerator {
  const DynamicLinkGenerator({required this.username, this.isAndroidLink = false});
  final String username;
  final bool isAndroidLink;

  Future<String> generateDynamicLink() async {
    final linkToOpen = Uri(
      scheme: 'https',
      host: _host,
      path: '/$username',
    );

    final androidUri = Uri(
      scheme: 'https',
      host: _host,
      path: '/android/$username',
    );

    final parameters = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      //URL will Redirect to this link.
      link: linkToOpen,
      androidParameters: AndroidParameters(
        packageName: 'com.fyp.conic',
        fallbackUrl: isAndroidLink ? linkToOpen : androidUri,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.fyp.conic',
        fallbackUrl: linkToOpen,
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );

    // debugPrint('LONG LINk ${await parameters.buildUrl()}\n\n');

    return (await parameters.buildShortLink()).shortUrl.toString();
  }
}
