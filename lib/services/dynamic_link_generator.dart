import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../res/constants.dart';

const _host = 'conic-688fe.web.app';

@immutable
class DynamicLinkGenerator {
  const DynamicLinkGenerator({
    required this.username,
    required this.userId,
    this.isProfile = true,
    this.isAndroidLink = false,
    this.isCard = false,
  });

  const DynamicLinkGenerator.android({
    required this.username,
    required this.userId,
    this.isAndroidLink = true,
    this.isProfile = true,
    this.isCard = false,
  });

  final String username;
  final String userId;
  final bool isAndroidLink;
  final bool isProfile;
  final bool isCard;

  Future<String> generateDynamicLink() async {
    final linkToOpen = Uri(
      scheme: 'https',
      host: _host,
      queryParameters: <String, String>{
        'username': username,
        'userid': userId,
        'isProfile': isProfile.toString(),
        'isCard': isCard.toString(),
        'androidLink': isAndroidLink.toString(),
      },
    );

    log('Link To Open: $linkToOpen', name: 'DynamicLinkGenerator');

    final parameters = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      //URL will Redirect to this link.
      link: linkToOpen,
      androidParameters: AndroidParameters(
        packageName: 'com.fyp.conic',
        fallbackUrl: linkToOpen,
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
