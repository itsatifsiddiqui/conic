import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/app_user.dart';
import '../res/constants.dart';
import 'app_user_provider.dart';

final firestoreProvider = Provider.autoDispose<FirestoreProvider>((ref) {
  return FirestoreProvider(ref.read);
});

class FirestoreProvider {
  FirestoreProvider(this._read);
  final Reader _read;
  final _firestore = FirebaseFirestore.instance;

  Future<AppUser?> getCurrentUser(String userId) async {
    final user = await _firestore.collection('users').doc(userId).get();
    if (user.exists) {
      return AppUser.fromMap(user.data()!);
    }
    return null;
  }

  Future<AppUser> createUser() async {
    final appUser = _read(appUserProvider.notifier).user!;
    try {
      final docRef = _firestore.collection('users').doc(appUser.userId);
      await docRef.set(appUser.toMap(), SetOptions(merge: true));
      return appUser;
    } catch (e) {
      showExceptionDialog(e);
      rethrow;
    }
  }

  Future<AppUser> updateUser() async {
    final appUser = _read(appUserProvider.notifier).user!;
    try {
      final docRef = _firestore.collection('users').doc(appUser.userId);
      await docRef.update(appUser.toMap());
      return appUser;
    } catch (e) {
      debugPrint(e.toString());
      showExceptionDialog(e);
      rethrow;
    }
  }
}
