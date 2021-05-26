import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  PickedFile? imageFile;

  Future<PickedFile?> pickImage({
    bool shouldCompress = true,
    bool shouldCrop = true,
    String? title,
    String? button1Text,
    String? button2Text,
    String? cancelButtonText,
  }) async {
    if (kIsWeb) {
      imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    } else {
      imageFile = await showChoicesAndGetImage(
        title: title,
        button1Text: button1Text,
        button2Text: button2Text,
        cancelButtonText: cancelButtonText,
      );
    }

    if (imageFile == null) {
      return null;
    }

    if (shouldCrop) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(Get.context!).primaryColor,
          initAspectRatio: CropAspectRatioPreset.square,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
        ),
      );
      if (croppedFile == null) return null;
      imageFile = PickedFile(croppedFile.path);
    }
    return imageFile;
  }

  Future<PickedFile?> showChoicesAndGetImage({
    String? title,
    String? button1Text,
    String? button2Text,
    String? cancelButtonText,
  }) async {
    final context = Get.context!;
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(title ?? 'Change Profile Photo'),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () async {
                final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  Navigator.pop(context, pickedImage);
                }
              },
              child: Text(button1Text ?? 'Pick From Gallery'),
            ),
            CupertinoButton(
              onPressed: () async {
                final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  Navigator.pop(context, pickedImage);
                }
              },
              child: Text(button2Text ?? 'Pick From Camera'),
            ),
          ],
          cancelButton: CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelButtonText ?? 'Cancel'),
          ),
        );
      },
    );
  }
}
