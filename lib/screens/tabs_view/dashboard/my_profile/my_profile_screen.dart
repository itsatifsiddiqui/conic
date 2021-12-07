import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/app_user_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/firebase_storage_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../res/platform_dialogue.dart';
import '../../../../res/res.dart';
import '../../../../services/image_picker_service.dart';
import '../../../../widgets/custom_widgets.dart';

class MyProfileScreen extends HookWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = useProvider(appUserProvider);
    final nameController = useTextEditingController(text: user!.name);
    return WillPopScope(
      onWillPop: () async {
        if (nameController.text.trim() != user.name) {
          final result = await showPlatformDialogue(
            title: 'Do you want to update your name?',
            action1OnTap: true,
            action1Text: 'Yes',
            action2OnTap: false,
            action2Text: 'No',
          );
          if (result ?? false) {
            context.read(appUserProvider.notifier).updateName(nameController.text.trim());
            // ignore: unawaited_futures
            context.read(firestoreProvider).updateUser();
          }
        }

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: 'My Profile'.text.semiBold.color(context.adaptive).make(),
          actions: [
            'Save'.text.xl.semiBold.color(context.primaryColor).make().p16().mdClick(() {
              context.read(appUserProvider.notifier).updateName(nameController.text.trim());
              context.read(firestoreProvider).updateUser();
              Get.back<void>();
            }).make(),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  const _ImageBuilder().py24(),
                  FilledTextField(
                    disabled: true,
                    controller: TextEditingController(text: user.username),
                    title: 'Username',
                  ),
                  if (user.email != null) ...[
                    12.heightBox,
                    FilledTextField(
                      disabled: true,
                      controller: TextEditingController(text: user.email),
                      title: 'Email',
                    ),
                  ],
                  12.heightBox,
                  FilledTextField(
                    controller: nameController,
                    title: 'Name',
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  12.heightBox,
                  HookBuilder(builder: (context) {
                    final hidden = useProvider(appUserProvider)!.hiddenMode ?? false;
                    return ListTile(
                      title: 'Hide Mode'.text.make(),
                      subtitle: (hidden
                              ? 'Account marked as hidden are not visible to others now'
                              : 'All accounts are visible to other users')
                          .text
                          .make()
                          .pOnly(top: 4),
                      onTap: () {
                        context.read(appUserProvider.notifier).updateHiddentMode(!hidden);
                        context.read(firestoreProvider).updateUser();
                      },
                      trailing: CupertinoSwitch(
                        value: hidden,
                        onChanged: (value) {
                          context.read(appUserProvider.notifier).updateHiddentMode(!hidden);
                          context.read(firestoreProvider).updateUser();
                        },
                      ),
                    );
                  })
                ],
              ).px16().scrollVertical().expand(),
              PrimaryButton(
                onTap: () {
                  context.read(authProvider).signOut();
                },
                text: 'Log out',
              ).p16()
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageBuilder extends HookWidget {
  const _ImageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUploading = useState(false);
    final imageUrl = useProvider(appUserProvider)!.image;
    if (isUploading.value) {
      return Container(
        width: 0.1.sh,
        height: 0.1.sh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.adaptive12),
          color: context.adaptive12,
        ),
        child: const CupertinoActivityIndicator(),
      );
    }
    return GestureDetector(
      onTap: () async {
        try {
          final imagePicerService = ImagePickerService();
          final pickedFile = await imagePicerService.pickImage();
          if (pickedFile == null) return;
          isUploading.value = true;
          final file = File(pickedFile.path);
          final imageUrl =
              await context.read(firebaseStorageProvider).uploadFile(file, 'profile_images');
          context.read(appUserProvider.notifier).updateProfileImage(imageUrl);
          await context.read(firestoreProvider).updateUser();
        } catch (e) {
          showExceptionDialog(e);
        } finally {
          isUploading.value = false;
        }
      },
      child: Column(
        children: [
          if (imageUrl == null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 0.1.sh,
                height: 0.1.sh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.adaptive12),
                  color: context.adaptive12,
                ),
                child: Icon(Icons.person_add_alt, color: context.adaptive75),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 0.1.sh,
                height: 0.1.sh,
                placeholder: kImagePlaceHodler,
              ),
            ),
          8.heightBox,
          'Edit Image'.text.sm.medium.color(AppColors.link).makeCentered()
        ],
      ),
    );
  }
}
