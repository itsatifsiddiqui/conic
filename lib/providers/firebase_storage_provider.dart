import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'base_provider.dart';

final firebaseStorageProvider = ChangeNotifierProvider<FirebaseStorageProvider>((ref) {
  return FirebaseStorageProvider();
});

class FirebaseStorageProvider extends BaseProvider {
  final _firebaseStorage = FirebaseStorage.instance;
  Future<String?> uploadProfile(File file) async {
    try {
      setBusy();
      final storageReference = _firebaseStorage
          .ref()
          .child('profile_images')
          .child('${DateTime.now().millisecondsSinceEpoch} ${file.path}');
      UploadTask? uploadTask;
      uploadTask = storageReference.putFile(file);
      final completer = Completer<void>();
      final taskSnapshot = await uploadTask.whenComplete(completer.complete);
      await completer.future;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      setIdle();
      return imageUrl;
    } catch (e) {
      setIdle();
      return null;
    }
  }

  Future<String?> uploadFile(File file, String path) async {
    try {
      setBusy();
      final storageReference = _firebaseStorage
          .ref()
          .child(path)
          .child('${DateTime.now().millisecondsSinceEpoch} ${file.path}');
      UploadTask? uploadTask;
      uploadTask = storageReference.putFile(file);
      final completer = Completer<void>();
      final taskSnapshot = await uploadTask.whenComplete(completer.complete);
      await completer.future;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      setIdle();
      return imageUrl;
    } catch (e) {
      setIdle();
      return null;
    }
  }
}
