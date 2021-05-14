import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/app_user.dart';
import '../res/extension.dart';

final appUserProvider = StateNotifierProvider<AppUserProvider, AppUser?>(
    (ref) => AppUserProvider());

class AppUserProvider extends StateNotifier<AppUser?> {
  AppUserProvider() : super(null);

  AppUser? get user => state;

  void overrideUser(AppUser? user) => state = user;

  void subscibeToUserStream(String uid) {
    final snapshots =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    snapshots.listen((event) {
      if (event.doesNotExist) return;
      try {
        state = AppUser.fromMap(event.data()!);
        debugPrint('USERSTREAMUPDATED');
      } catch (e) {
        log(e.toString(), name: 'subscibeToUserStream');
      }
    });
  }

  void overrideFromFirebaseUser(User user) {
    state = AppUser(
      userId: user.uid,
      email: user.email,
      name: user.displayName,
      image: user.photoURL,
    );
  }

  void overrideFromAppleUser(String uid, String email, String displayName) {
    state = AppUser(
      userId: uid,
      email: email,
      name: displayName,
    );
  }

  String get userId => state!.userId!;
}
