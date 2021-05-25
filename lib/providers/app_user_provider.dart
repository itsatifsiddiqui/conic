import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/app_user.dart';
import '../models/linked_account.dart';
import '../res/extension.dart';

final appUserProvider = StateNotifierProvider<AppUserProvider, AppUser?>(
  (ref) => AppUserProvider(),
);

class AppUserProvider extends StateNotifier<AppUser?> {
  AppUserProvider() : super(null);

  AppUser? get user => state;

  void overrideUser(AppUser? user) => state = user;

  void subscibeToUserStream(String uid) {
    final snapshots = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
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

  void updateUsername({
    required String username,
    required String link,
    required String androidLink,
  }) {
    state = state!.copyWith(
      username: username,
      link: link,
      androidLink: androidLink,
    );
  }

  void addAccount(LinkedAccount linkedAccount) {
    final linkedAccounts = state!.linkedAccounts ?? [];
    linkedAccounts.add(linkedAccount);
    state = state!.copyWith(linkedAccounts: linkedAccounts);
  }

  void removeAccount(LinkedAccount account) {
    final linkedAccounts = state!.linkedAccounts ?? [];
    linkedAccounts.remove(account);
    state = state!.copyWith(linkedAccounts: linkedAccounts);
  }

  void editAccount(LinkedAccount editedAccount, LinkedAccount linkedAccount) {
    final linkedAccounts = state!.linkedAccounts ?? [];
    final index = linkedAccounts.indexOf(linkedAccount);
    linkedAccounts[index] = editedAccount;
    state = state!.copyWith(linkedAccounts: linkedAccounts);
  }

  void updateListMode() {
    final gridMode = state!.gridMode ?? true;
    state = state!.copyWith(gridMode: !gridMode);
  }

  void updateName(String? value) {
    state = state!.copyWith(name: value);
  }
}
