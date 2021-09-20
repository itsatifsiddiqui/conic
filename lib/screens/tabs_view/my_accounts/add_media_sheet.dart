import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../providers/firebase_storage_provider.dart';
import '../../../res/res.dart';

class AddMediaSheet extends HookWidget {
  const AddMediaSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 48,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: context.adaptive26,
          ),
        ),
        ListTile(
          onTap: () async {
            final image = await ImagePicker().getImage(source: ImageSource.gallery);
            if (image == null) return;
            // ignore: unawaited_futures
            context.read(firebaseStorageProvider).uploadMedia(File(image.path), 'image');
            Navigator.of(context).pop();
          },
          title: 'Add Image'.text.medium.make(),
          trailing: const Icon(Icons.chevron_right_outlined),
        ),
        ListTile(
          onTap: () async {
            final video = await ImagePicker().getVideo(source: ImageSource.gallery);
            if (video == null) return;
            // ignore: unawaited_futures
            context.read(firebaseStorageProvider).uploadMedia(File(video.path), 'video');
            Navigator.of(context).pop();
          },
          title: 'Add Video'.text.medium.make(),
          trailing: const Icon(Icons.chevron_right_outlined),
        ),
        ListTile(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              allowedExtensions: ['pdf'],
              dialogTitle: 'Pick pdf file',
              type: FileType.custom,
            );
            if (result == null || result.files.isEmpty) {
              return;
            }

            final pdf = result.files.first;

            // ignore: unawaited_futures
            context.read(firebaseStorageProvider).uploadMedia(File(pdf.path!), 'pdf');
            Navigator.of(context).pop();
          },
          title: 'Add Pdf'.text.medium.make(),
          trailing: const Icon(Icons.chevron_right_outlined),
        ),
      ],
    );
  }

  static void openMediaSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBorderRadius),
        ),
      ),
      builder: (context) {
        return const AddMediaSheet();
      },
    );
  }
}
