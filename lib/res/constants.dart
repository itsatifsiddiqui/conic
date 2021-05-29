import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import 'platform_dialogue.dart';

double kBorderRadius = 6;
const dynamicLinkPrefix = 'https://conic.page.link';

Future<void> kOpenLink(String url) async {
  debugPrint('OPENING URL: $url');
  if (await canLaunch(url)) {
    try {
      final result = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      debugPrint(result.toString());
      if (!result) {
        await launch(url);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    // ignore: unawaited_futures
    launch(url);
    debugPrint('UNABLE TO OPEN');
  }
}

// const String kSupportMail = 'appsupport@draughtguardian.com';

// Widget kImagePlaceHolder(_, __) {
//   return Center(child: CupertinoActivityIndicator());
// }

// Widget kErrorWidget(_, __, ___) => Center(child: Icon(Icons.error_outline, color: Colors.red));

void showExceptionDialog(dynamic e) {
  if (e is SocketException) {
    showPlatformDialogue(
      title: 'Network Error',
      content: const Text("Seems like, you're not connected to internet"),
    );
    return;
  }
  if (e is FirebaseAuthException) {
    log(e.code);
    if (e.code == 'user-not-found') {
      showPlatformDialogue(
        title: 'User Not Found',
        content: const Text('No user correspond to this email. Try signing up.'),
      );
    } else if (e.code == 'operation-not-allowed') {
      showPlatformDialogue(
        title: 'Provider not enabled',
        content: const Text('Sign in method not enabled in firebase console.'),
      );
    } else if (e.code == 'internal-error') {
      showPlatformDialogue(
        title: 'Internal Error',
        content: const Text(
          'Firebase Authentication not enabled in firebase console.',
        ),
      );
    } else if (e.code == 'wrong-password') {
      showPlatformDialogue(
        title: 'Wrong Password',
        content: const Text(
          'The entered password is incorrect. Please try with correct password or try resetting password.',
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      showPlatformDialogue(
        title: 'Email already in use',
        content: const Text(
          'This email is already in use by another provider. Please sign in with correct provider.',
        ),
      );
    } else {
      showPlatformDialogue(
        title: 'Error',
        content: Text(e.message?.toString() ?? 'Unknown Error'),
      );
    }

    return;
  }

  if (e is SignInWithAppleAuthorizationException) {
    if (e.code == AuthorizationErrorCode.unknown) {
      showPlatformDialogue(
        title: 'Unknown Error',
        content: Text(e.message),
      );
    } else if (e.code == AuthorizationErrorCode.canceled) {
      return;
    } else if (e.code == AuthorizationErrorCode.failed) {
      showPlatformDialogue(
        title: 'Failed to login',
        content: Text(e.message),
      );
    } else if (e.code == AuthorizationErrorCode.invalidResponse) {
      showPlatformDialogue(
        title: 'Invalid Response',
        content: Text(e.message),
      );
    } else if (e.code == AuthorizationErrorCode.notHandled) {
      showPlatformDialogue(
        title: 'Not handled error',
        content: Text(e.message),
      );
    }
    return;
  }

  log(e.runtimeType.toString(), name: 'showExceptionDialog');
  showPlatformDialogue(
    title: 'Error',
    content: Text(e.toString()),
  );
}

Future<Position?> kCheckAndAskForLocationPermission() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    final result = await showPlatformDialogue(
      title: 'Please Enable Location your location first',
      action1OnTap: true,
      action1Text: 'Open Location Setting',
      action2OnTap: false,
      action2Text: 'Ok',
    );
    if (result ?? false) {
      await OpenSettings.openLocationSourceSetting();
    }
    return null;
  }
  //ASK Location PERMISSION
  final locationPermission = await Permission.location.isGranted;
  if (!locationPermission) {
    final locationPermissionStatus = await Permission.location.request();
    if (locationPermissionStatus == PermissionStatus.permanentlyDenied) {
      final result = await showPlatformDialogue(
        title: 'Location Permission is required',
        content: const Text(
          'Go to settings and give access to use location',
        ),
        action1OnTap: true,
        action1Text: 'Open Location Setting',
        action2OnTap: false,
        action2Text: 'Ok',
      );
      if (result ?? false) {
        await OpenSettings.openLocationSourceSetting();
      }
      return null;
    }
    if (locationPermissionStatus == PermissionStatus.denied) {
      final result = await showPlatformDialogue(
        title: 'Location Permission is required',
        content: const Text(
          'Go to settings and give access to use location',
        ),
        action1OnTap: true,
        action1Text: 'Open Location Setting',
        action2OnTap: false,
        action2Text: 'Ok',
      );
      if (result ?? false) {
        await OpenSettings.openLocationSourceSetting();
      }
      return null;
    }
  }

  return Geolocator.getCurrentPosition();
}
