import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'my_app.dart';
import 'providers/firebase_messaging_provider.dart';

Future<void> main() async {
  log('hello -1');
  WidgetsFlutterBinding.ensureInitialized();
  log('hello 0');
  await Firebase.initializeApp();
  log('hello 1');
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  //FCM
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // ignore: unawaited_futures
  FirebaseMessagingProvider.init();

  runApp(const ProviderScope(child: MyApp()));
}
