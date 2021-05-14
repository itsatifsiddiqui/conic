import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../res/constants.dart';

@immutable
class DynamicLinkGenerator {
  const DynamicLinkGenerator(
      {required this.username, this.isAndroidLink = false});
  final String username;
  final bool isAndroidLink;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DynamicLinkGenerator &&
        other.username == username &&
        other.isAndroidLink == isAndroidLink;
  }

  @override
  int get hashCode => username.hashCode ^ isAndroidLink.hashCode;

  Future<String> generateDynamicLink() async {
    final uri = Uri(
      scheme: 'https',
      host: 'conic.page.link',
      path: '/$username',
    );

    final androidUri = Uri(
      scheme: 'https',
      host: 'conic.page.link',
      path: '/android/$username',
    );

    final parameters = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: uri,
      androidParameters: AndroidParameters(
        packageName: 'com.fyp.conic',
        fallbackUrl: isAndroidLink ? androidUri : uri,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.fyp.conic',
        fallbackUrl: uri,
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );

    // debugPrint('LONG LINk ${await parameters.buildUrl()}\n\n');

    return (await parameters.buildShortLink()).shortUrl.toString();
  }
}
