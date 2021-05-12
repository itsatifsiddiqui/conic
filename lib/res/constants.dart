// import 'dart:io';

// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'platform_dialogue.dart';

double kBorderRadius = 6;
// const String kSupportMail = 'appsupport@draughtguardian.com';

// Widget kImagePlaceHolder(_, __) {
//   return Center(child: CupertinoActivityIndicator());
// }

// Widget kErrorWidget(_, __, ___) => Center(child: Icon(Icons.error_outline, color: Colors.red));

// void showExceptionDialog(dynamic e) {
//   if (e is SocketException) {
//     showPlatformDialogue(
//       title: 'Network Error',
//       content: Text("Seems like, you're not connected to internet"),
//     );
//   } else if (e is FirebaseAuthException) {
//     if (e.code == 'user-not-found') {
//       showPlatformDialogue(
//         title: 'User Not Found',
//         content: Text('No user correspond to this email. Try signing up.'),
//       );
//     } else {
//       showPlatformDialogue(
//         title: 'Error',
//         content: Text(e.message),
//       );
//     }
//   } else if (e is DioError) {
//     if (e.message.toLowerCase().contains('SocketException'.toLowerCase())) {
//       showPlatformDialogue(
//         title: 'Network Error',
//         content: Text("Seems like, you're not connected to internet"),
//       );
//     } else {
//       showPlatformDialogue(
//         title: 'Error',
//         content: Text(e.message),
//       );
//     }
//   } else {
//     showPlatformDialogue(
//       title: 'Error',
//       content: Text(e.toString()),
//     );
//   }
// }
