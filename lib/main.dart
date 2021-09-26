import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'my_app.dart';
import 'providers/qrcode_widget_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await QRCodeWidget.init();

  runApp(const ProviderScope(child: MyApp()));
}
