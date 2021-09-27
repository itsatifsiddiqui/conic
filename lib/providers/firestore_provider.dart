import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/account_model.dart';
import '../models/app_user.dart';
import '../models/linked_account.dart';
import '../models/linked_media.dart';
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

  Stream<AppUser> getUserById(String userId) {
    final user = _firestore.collection('users').doc(userId).snapshots();
    return user.map((event) => AppUser.fromMap(event.data()!));
  }

  Future<AppUser> getUserDataById(String userId) async {
    final user = await _firestore.collection('users').doc(userId).get();
    return AppUser.fromMap(user.data()!);
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

  //Ahmed followed by Atif and faisal.
  Stream<List<AppUser>> getMyFollowers(String myId) {
    final snaps =
        _firestore.collection('users').where('followedBy', arrayContains: myId).snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }

  Stream<List<AppUser>> getUsersIFollow(String userId) {
    final snaps =
        _firestore.collection('users').where('isFollowing', arrayContains: userId).snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }

  void followUser(String followedUserId) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(followedUserId).update({
      'isFollowing': FieldValue.arrayUnion(<String>[myId])
    });
  }

  void unfollowUser(String followedUserId) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(followedUserId).update({
      'isFollowing': FieldValue.arrayRemove(<String>[myId])
    });
  }

  void removeFollower(String followerId) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(followerId).update({
      'followedBy': FieldValue.arrayRemove(<String>[myId])
    });
  }

  ///Append Currently Signed in user's id to searched users followRequestsRecieved list
  ///Also send the notification
  void sendFollowRequest(String userId) {
    final currentUserId = _read(appUserProvider)!.userId!;
    final batch = _firestore.batch();
    final usersCollection = _firestore.collection('users');
    final otherUserDoc = usersCollection.doc(userId);
    final sendRequestData = {
      'followRequestsRecieved': FieldValue.arrayUnion(<String>[currentUserId]),
    };
    final followRequestsCollection =
        _firestore.collection('users').doc(userId).collection('follow_requests_sent').doc();
    final followRequestData = <String, dynamic>{
      'currentUserId': currentUserId,
      'otherUserId': userId,
    };
    batch.set(followRequestsCollection, followRequestData);
    batch.update(otherUserDoc, sendRequestData);
    batch.commit();
  }

  void unSendFollowRequest(String userId) {
    final currentUserId = _read(appUserProvider)!.userId!;
    final batch = _firestore.batch();
    final usersCollection = _firestore.collection('users');
    final otherUserDoc = usersCollection.doc(userId);
    final unsendRequestData = {
      'followRequestsRecieved': FieldValue.arrayRemove(<String>[currentUserId]),
    };
    batch.update(otherUserDoc, unsendRequestData);
    batch.commit();
  }

  void confirmFollowRequest(String requestedUserId) {
    final myId = _read(appUserProvider)!.userId!;
    final usersCollection = _firestore.collection('users');
    final batch = _firestore.batch();
    final myDoc = usersCollection.doc(myId);
    final removeData = {
      'followRequestsRecieved': FieldValue.arrayRemove(<String>[requestedUserId]),
      'isFollowing': FieldValue.arrayUnion(<String>[requestedUserId]),
    };
    final requestedUserDoc = usersCollection.doc(requestedUserId);
    final requestedUserData = {
      'followedBy': FieldValue.arrayUnion(<String>[myId]),
    };
    final followRequestsConfirmed =
        _firestore.collection('users').doc(myId).collection('follow_requests_confirmed').doc();
    final followRequestsConfirmedData = <String, dynamic>{
      'currentUserId': requestedUserId,
      'otherUserId': myId,
    };

    batch.set(followRequestsConfirmed, followRequestsConfirmedData);
    batch.update(myDoc, removeData);
    batch.update(requestedUserDoc, requestedUserData);
    batch.commit();
  }

  void discardFolowRequest(String userId) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(myId).update({
      'followRequestsRecieved': FieldValue.arrayRemove(<String>[userId]),
    });
  }

  Stream<List<AppUser>> getFollowRequestsLessThan10(List<String> followRequestsRecieved) {
    final snaps = _firestore
        .collection('users')
        .where('followRequestsRecieved', whereIn: followRequestsRecieved)
        .snapshots();
    return snaps.map((event) => event.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }

  Stream<List<AppUser>> getFollowRequestsLessAbove10(List<String> followRequestsRecieved) async* {
    final usersCollection = _firestore.collection('users');

    final docsFuture = followRequestsRecieved.map((e) => usersCollection.doc(e).get()).toList();

    final docs = await Future.wait(docsFuture);

    final mapped = docs.map((e) => AppUser.fromMap(e.data()!)).toList();

    yield mapped;
  }

  void makeMeVisible(GeoFirePoint myLocation) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(myId).update(
      <String, dynamic>{'location': myLocation.data},
    );
  }

  void makeMeInVisible() {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(myId).update(
      <String, dynamic>{'location': null},
    );
  }

  void addMedia(LinkedMedia media) {
    final myId = _read(appUserProvider)!.userId!;
    _firestore.collection('users').doc(myId).update(
      <String, dynamic>{
        'linkedMedias': FieldValue.arrayUnion(
          <Map<String, dynamic>>[media.toMap()],
        ),
      },
    );
  }

  void sendAccountChangeNotification(LinkedAccount? linkedAccount, {bool newAccount = true}) {
    if (!(linkedAccount?.notify ?? false)) return;

    final userId = _read(appUserProvider)!.userId!;
    final userName = _read(appUserProvider)!.name;
    final followedBy = _read(appUserProvider)!.followedBy;
    final docRef =
        _firestore.collection('users').doc(userId).collection('sent_notifications').doc();
    docRef.set(<String, dynamic>{
      'userId': userId,
      'userName': userName ?? 'user',
      'accountName': linkedAccount?.name ?? 'Profile',
      'newAccount': newAccount,
      'followedBy': followedBy,
    });
  }

  Future<void> addDeviceToken(String token) async {
    final userId = _read(appUserProvider)!.userId!;
    await _firestore.collection('users').doc(userId).update(<String, dynamic>{
      'tokens': FieldValue.arrayUnion(<String>[token])
    });
  }

  Future<void> removeDeviceToken(String token) async {
    final userId = _read(appUserProvider)!.userId!;
    await _firestore.collection('users').doc(userId).update(<String, dynamic>{
      'tokens': FieldValue.arrayRemove(<String>[token])
    });
  }

  Stream<QuerySnapshot> getNotifications() {
    final userId = _read(appUserProvider)!.userId!;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
