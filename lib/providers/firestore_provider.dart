import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/account_model.dart';
import '../models/app_user.dart';
import '../res/constants.dart';
import '../screens/add_account/add_new_account_screen.dart';
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

  Future<bool> isUsernameAvailable(String username) async {
    try {
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      if (docs.docs.isEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Stream<List<AccountModel>> getAllAccounts() {
    final snaps = _firestore.collection('accounts').doc('all_accounts').snapshots();
    return snaps.map((event) {
      final hasAccounts = (event.data() ?? <String, dynamic>{}).containsKey('all_accounts');
      var allAccounts = <AccountModel>[];
      if (hasAccounts) {
        final accountsListD = event.data()!['all_accounts'] as List<dynamic>;
        final accountsList = accountsListD.cast<Map<String, dynamic>>();
        allAccounts = accountsList.map((e) => AccountModel.fromMap(e)).toList();
      }
      _read(allAccountsStateProvider).state = allAccounts;
      return allAccounts;
    });
  }

  Stream<List<AppUser>> getFollowings() {
    return Stream.value(<AppUser>[]);
  }

  Stream<List<AppUser>> getFollowers() {
    final userId = _read(appUserProvider)!.userId;
    final snaps =
        _firestore.collection('users').where('followedBy', arrayContains: userId).snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }
}
