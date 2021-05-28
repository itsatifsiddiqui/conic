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

  Future<AppUser?> searchUserByUsername(String username) async {
    try {
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      if (docs.docs.isNotEmpty) {
        return AppUser.fromMap(docs.docs.first.data());
      }
      return null;
    } catch (e) {
      return null;
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

  Stream<List<AppUser>> getFollowings(String userId) {
    final snaps =
        _firestore.collection('users').where('followings', arrayContains: userId).snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }

  Stream<List<AppUser>> getFollowers(String userId) {
    final snaps =
        _firestore.collection('users').where('followedBy', arrayContains: userId).snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }

  void unfollowUser(String userId) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(userId).update({
      'followings': FieldValue.arrayRemove(<String>[myId])
    });
  }

  void removeUser(String userId) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(userId).update({
      'followedBy': FieldValue.arrayRemove(<String>[myId])
    });
  }

  void sendFollowRequest(String userId) {
    final myId = _read(appUserProvider)!.userId!;
    final batch = _firestore.batch();
    final usersCollection = _firestore.collection('users');
    final myDoc = usersCollection.doc(myId);
    final sentRequestData = {
      'sentRequests': FieldValue.arrayUnion(<String>[userId])
    };
    final otherUserDoc = usersCollection.doc(userId);
    final recievedRequestData = {
      'recievedRequests': FieldValue.arrayUnion(<String>[myId])
    };
    final followData = {
      'followings': FieldValue.arrayUnion(<String>[myId])
    };
    batch.update(myDoc, sentRequestData);
    batch.update(otherUserDoc, followData);
    batch.update(otherUserDoc, recievedRequestData);

    batch.commit();
  }

  void unSendFollowRequest(String userId) {
    final myId = _read(appUserProvider)!.userId!;
    final batch = _firestore.batch();
    final usersCollection = _firestore.collection('users');

    final myDoc = usersCollection.doc(myId);
    final requestAddData = {
      'sentRequests': FieldValue.arrayRemove(<String>[userId])
    };
    final otherUserDoc = usersCollection.doc(userId);
    final followData = {
      'followings': FieldValue.arrayRemove(<String>[myId])
    };
    batch.update(myDoc, requestAddData);
    batch.update(otherUserDoc, followData);

    batch.commit();
  }

  Stream<List<AppUser>> getFollowRequests(String userId) {
    final snaps =
        _firestore.collection('users').where('sentRequests', arrayContains: userId).snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }
}
