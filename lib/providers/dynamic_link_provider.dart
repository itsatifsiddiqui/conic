import 'dart:async';
import 'dart:developer';
import 'package:conic/providers/firestore_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_provider.dart';

enum LinkStatus { noLink, loggedIn, notLoggedIn }

final dynamicLinkProvider = Provider<DynamicLinkProvider>((ref) {
  return DynamicLinkProvider(ref.read);
});

class DynamicLinkProvider {
  DynamicLinkProvider(this._read) {
    getDynamicLink();
  }
  final Reader _read;

  LinkStatus linkStatus = LinkStatus.noLink;
  String? linkShareUserId;

  Future<void> getDynamicLink() async {
    final dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    log('Dynamic Link: $dynamicLink', name: 'DynamicLinkProvider');
    if (dynamicLink != null) {
      await handleDeepLink(dynamicLink);
    } else {
      _read(authProvider).onLinkStatusChanged.value = LinkStatus.noLink;
      // ignore: unawaited_futures
      _read(authProvider).navigateBasedOnCondition();
    }

    FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
      handleDeepLink(pendingDynamicLinkData);
    }, onError: (_) {
      log('DYNAMIC LINK ONLINK ERROR ${_.toString()}', name: 'DynamicLinkProvider');
      linkStatus = LinkStatus.noLink;
      _read(authProvider).onLinkStatusChanged.value = linkStatus;
      // return Future<bool>.value(false);
    });
    // onSuccess:
    // onError: (error) {

    // },
    // );
  }

  Future<void> handleDeepLink(PendingDynamicLinkData? dynamicLink) async {
    try {
      log('handleDyanmicLink()', name: 'DynamicLinkProvider');

      _read(authProvider).onLinkStatusChanged.value = LinkStatus.noLink;
      final deepLink = dynamicLink?.link;
      log(
        'HERE IS THE DEEP LINK PATH SEGMENTS ${deepLink?.queryParameters.toString()}',
        name: 'DynamicLinkProvider',
      );
      final userId = deepLink?.queryParameters['userid'];

      if (userId != null) {
        linkShareUserId = userId;
        if (FirebaseAuth.instance.currentUser == null) {
          log('NO LOGGED IN USER ', name: 'DynamicLinkProvider');
          linkStatus = LinkStatus.notLoggedIn;
          _read(authProvider).onLinkStatusChanged.value = linkStatus;
          return;
        }

        linkStatus = LinkStatus.loggedIn;
        _read(authProvider).onLinkStatusChanged.value = linkStatus;
        _read(firestoreProvider).updateNfcValue(userId);
        // var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        // _read(firestoreProvider).addingLocation(userId, LatLng(position.latitude, position.longitude));
        _read(firestoreProvider).updateStreak();
        log('LINKSTATUS CHAGED TO $linkStatus', name: 'DynamicLinkProvider');
      }
    } catch (e) {
      log('handleDeepLink ERROR: ${e.toString()}', name: 'DynamicLinkProvider');
    }
  }
}
