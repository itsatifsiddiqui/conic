import 'package:conic/screens/add_account/add_new_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/app_user.dart';
import '../res/constants.dart';
import '../res/platform_dialogue.dart';
import '../screens/auth/login_screen.dart';
import '../screens/nfc/activate_nfc_screen.dart';
import '../screens/profile/username_setup_page.dart';
import '../screens/tabs_view/tabs_view.dart';
import '../services/dynamic_link_generator.dart';
import 'app_user_provider.dart';
import 'base_provider.dart';
import 'firestore_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref.read, ref);
});

class AuthProvider extends BaseProvider {
  AuthProvider(this._read, this.ref) {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _read(appUserProvider.notifier).subscibeToUserStream(user.uid);
      }
    });
  }
  final Reader _read;
  final ProviderReference ref;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isAppleSignInAvailable = false;
  Future checkAppleSignIn() async {
    isAppleSignInAvailable = await SignInWithApple.isAvailable();
  }

  bool get isUserLoggedIn => _auth.currentUser != null;

  User get user => _auth.currentUser!;

  Future navigateBasedOnCondition() async {
    if (isUserLoggedIn) {
      final appUser = await getCurrentUser();

      if (appUser.username?.isEmpty ?? true) {
        // ignore: unawaited_futures
        Get.offAll<void>(() => const UsernameSetupScreen());
      } else {
        // ignore: unawaited_futures
        navigateToTabsPage(user);
      }
    } else {
      // ignore: unawaited_futures
      Get.offAll<void>(() => const LoginScreen());
    }
    setIdle();
  }

  Future<void> navigateToTabsPage(User firebaseUser) async {
    // ignore: unawaited_futures
    Get.offAll<void>(() => const TabsView());
  }

  Future<AppUser> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      final appUser = await _read(firestoreProvider).getCurrentUser(user!.uid);
      _read(appUserProvider.notifier).overrideUser(appUser);
      return appUser!;
    } catch (e) {
      await signOut();
      rethrow;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    setBusy();

    try {
      final userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      _read(appUserProvider.notifier).overrideFromFirebaseUser(userCredential.user!);

      await navigateBasedOnCondition();
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future<void> loginWithGoogle() async {
    setBusy();
    try {
      final googleSignin = await GoogleSignIn().signIn();
      if (googleSignin == null) {
        setIdle();
        return;
      }
      final googleAuth = await googleSignin.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final currentUser = await _read(firestoreProvider).getCurrentUser(userCredential.user!.uid);
      if (currentUser == null) {
        _read(appUserProvider.notifier).overrideFromFirebaseUser(userCredential.user!);
        await _read(firestoreProvider).createUser();
      }
      setIdle();
      await navigateBasedOnCondition();
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future<void> loginWithFacebook() async {
    setBusy();
    try {
      final result = await FacebookLogin().logIn();
      switch (result.status) {
        case FacebookLoginStatus.success:
          {
            if (result.accessToken?.token == null) {
              setIdle();
              return;
            }
            final credential = FacebookAuthProvider.credential(result.accessToken!.token);
            final userCredential = await _auth.signInWithCredential(credential);
            final currentUser =
                await _read(firestoreProvider).getCurrentUser(userCredential.user!.uid);
            if (currentUser == null) {
              _read(appUserProvider.notifier).overrideFromFirebaseUser(userCredential.user!);
              await _read(firestoreProvider).createUser();
            }
            setIdle();
            await navigateBasedOnCondition();
            break;
          }
        case FacebookLoginStatus.cancel:
          setIdle();
          break;
        case FacebookLoginStatus.error:
          setIdle();
          break;
      }
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future loginWithApple() async {
    setBusy();
    try {
      final appleResult = await SignInWithApple.getAppleIDCredential(
        scopes: AppleIDAuthorizationScopes.values,
      );

      final credential = OAuthProvider('apple.com').credential(
        accessToken: appleResult.authorizationCode,
        idToken: appleResult.identityToken,
      );

      final name = '${appleResult.givenName ?? ''} ${appleResult.familyName ?? ""}';

      final userCredential = await _auth.signInWithCredential(credential);
      await userCredential.user?.updateProfile(displayName: name);

      final currentUser = await _read(firestoreProvider).getCurrentUser(userCredential.user!.uid);
      if (currentUser == null) {
        _read(appUserProvider.notifier).overrideFromAppleUser(
          userCredential.user!.uid,
          userCredential.user!.email ?? appleResult.email ?? '',
          name,
        );
        await _read(firestoreProvider).createUser();
      }
      setIdle();
      await navigateBasedOnCondition();

      // if (await firestoreProvider.getCurrentUser(userCredential.user.uid) ==
      //     null) {
      //   appUserProvider.overrideFromFirebaseUser(userCredential.user);
      //   await firestoreProvider.createUser();
      // }
      // setIdle();
      // navigateBasedOnCondition();
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future<void> registerWithEmailAndPassword(
    AppUser appuser,
    String password,
  ) async {
    setBusy();
    try {
      final userCredential =
          await _auth.createUserWithEmailAndPassword(email: appuser.email!, password: password);
      await userCredential.user!.updateProfile(displayName: appuser.name);

      _read(appUserProvider.notifier).overrideFromFirebaseUser(userCredential.user!);
      final user = _read(appUserProvider.notifier).user!.copyWith(
            name: appuser.name,
          );

      _read(appUserProvider.notifier).overrideUser(user);
      await _read(firestoreProvider).createUser();
      setIdle();
      await navigateBasedOnCondition();
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future<void> completeProfileSetup(String username) async {
    setBusy();
    try {
      final link = DynamicLinkGenerator(username: username).generateDynamicLink();
      final androidLink = DynamicLinkGenerator(
        username: username,
        isAndroidLink: true,
      ).generateDynamicLink();

      final links = await Future.wait([link, androidLink]);
      debugPrint(links.toString());
      ref.read(appUserProvider.notifier).updateUsername(
            username: username,
            link: links.first,
            androidLink: links.last,
          );

      await _read(firestoreProvider).updateUser();
      setIdle();
      // ignore: unawaited_futures
      Get.offAll<void>(() => const ActivateNfcScreen());
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future<void> passwordReset(String email) async {
    setBusy();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      await showPlatformDialogue(
        title: 'Email Sent',
        content: const Text('Please check your inbox to reset email'),
      );
      setIdle();
      Get.back<void>();
    } catch (e) {
      setIdle();
      showExceptionDialog(e);
    }
  }

  Future<void> signOut() async {
    // ignore: unawaited_futures
    Get.offAll<void>(() => const LoginScreen());
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookLogin().logOut();
    await Future<void>.delayed(500.milliseconds);
    debugPrint('OVERRIDING USER TO NULL');
    _read(tabsIndexProvider).state = 0;
    _read(appUserProvider.notifier).overrideUser(null);
  }
}
