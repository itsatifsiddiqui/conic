import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'my_app.dart';
import 'providers/firebase_messaging_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //FCM
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // ignore: unawaited_futures
  FirebaseMessagingProvider.init();

  runApp(const ProviderScope(child: MyApp()));
}
