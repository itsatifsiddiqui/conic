import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../models/account_model.dart';
import '../../models/linked_account.dart';
import '../../providers/app_user_provider.dart';
import '../../providers/firebase_storage_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../res/res.dart';
import '../../services/image_picker_service.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/primary_button.dart';

final imageFileProvider = StateProvider.autoDispose<File?>((ref) => null);

class AccountFormScreen extends HookWidget {
  const AccountFormScreen({
    Key? key,
    required this.account,
    this.linkedAccount,
  }) : super(key: key);

  final AccountModel account;
  final LinkedAccount? linkedAccount;
  @override
  Widget build(BuildContext context) {
    final fieldController = useTextEditingController(text: linkedAccount?.enteredLink);
    final fieldNode = useFocusNode();
    final titleController = useTextEditingController(text: linkedAccount?.title);
    final titleNode = useFocusNode();
    final descriptionController = useTextEditingController(text: linkedAccount?.description);
    final descriptionNode = useFocusNode();
    final formKey = GlobalObjectKey<FormState>(context);
    final isEditMode = linkedAccount != null;
    final isLoading = useProvider(firebaseStorageProvider.select((value) => value.isLoading));
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: FittedBox(
            child: '${isEditMode ? "" : "Edit"} ${account.name}'
                .text
                .xl
                .semiBold
                .color(context.adaptive)
                .make(),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  16.heightBox,
                  _ImageBuilder(
                    image: linkedAccount?.image ?? account.image,
                  ),
                  16.heightBox,
                  FilledTextField(
                    focusNode: fieldNode,
                    nextNode: titleNode,
                    controller: fieldController,
                    title: account.field,
                    hintText: account.fieldHint,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill in the ${account.field}';
                      }
                      if (account.isValidLink(value)) return null;
                      return 'Invalid ${account.field}';
                    },
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        FocusScope.of(context).unfocus();
                        final link = account.getLink(fieldController.text.trim());
                        kOpenLink(link);
                      },
                    ),
                  ),
                  12.heightBox,
                  FilledTextField(
                    focusNode: titleNode,
                    nextNode: descriptionNode,
                    controller: titleController,
                    title: 'Title',
                    hintText: '${account.title} (Optional)',
                    textInputAction: TextInputAction.next,
                  ),
                  12.heightBox,
                  FilledTextField(
                    minLines: 2,
                    maxLines: 4,
                    focusNode: descriptionNode,
                    controller: descriptionController,
                    title: 'Description',
                    hintText: '${account.description} (Optional)',
                    textInputAction: TextInputAction.done,
                  ),
                  12.heightBox,
                  _FocusedTile(account: linkedAccount),
                  8.heightBox,
                  _NotifyFollowersTile(account: linkedAccount),
                  8.heightBox,
                  _HiddenTile(account: linkedAccount),
                  24.heightBox,
                ],
              ).px24().scrollVertical().expand(),
            ),
            PrimaryButton(
              text: isEditMode ? 'Edit Account' : 'Add Account',
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                FocusScope.of(context).unfocus();
                final focused = context.read(focusedProvider(linkedAccount)).state;
                final notify = context.read(notifyFollowersProvider(linkedAccount)).state;
                final hidden = context.read(isHiddenProvider(linkedAccount)).state;
                final title = titleController.text.trim();
                final desc = descriptionController.text.trim();
                final enteredLink = fieldController.text.trim();
                final fullLink = account.getLink(enteredLink);

                final file = context.read(imageFileProvider).state;
                var image = account.image;
                if (file != null) {
                  final path = account.name;
                  image = (await context.read(firebaseStorageProvider).uploadFile(file, path)) ??
                      account.image;
                }
                final newlinkedAccount = LinkedAccount(
                  name: account.name,
                  image: image,
                  title: title,
                  description: desc,
                  enteredLink: enteredLink,
                  fullLink: fullLink,
                  focused: focused,
                  notify: notify,
                  hidden: hidden,
                  media: const [],
                );

                if (isEditMode) {
                  context
                      .read(appUserProvider.notifier)
                      .editAccount(newlinkedAccount, linkedAccount!);
                  // ignore: unawaited_futures
                  context.read(firestoreProvider).updateUser();
                  Get.back<void>();
                } else {
                  context.read(appUserProvider.notifier).addAccount(newlinkedAccount);
                  // ignore: unawaited_futures
                  context.read(firestoreProvider).updateUser();
                  Get.back<void>();
                }
              },
            ).px16().py8()
          ],
        )),
      ),
    );
  }
}

class _ImageBuilder extends HookWidget {
  const _ImageBuilder({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    final imageFile = useProvider(imageFileProvider).state;
    return GestureDetector(
      onTap: () async {
        final imagePicerService = ImagePickerService();
        final file = await imagePicerService.pickImage();
        if (file != null) {
          context.read(imageFileProvider).state = File(file.path);
        }
      },
      child: Column(
        children: [
          if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imageFile,
                width: 0.1.sh,
                height: 0.1.sh,
              ),
            )
          else
            Hero(
              tag: image,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: 0.1.sh,
                  height: 0.1.sh,
                ),
              ),
            ),
          8.heightBox,
          'Custom Photo'.text.sm.medium.color(AppColors.link).makeCentered()
        ],
      ),
    );
  }
}

final focusedProvider =
    StateProvider.family<bool, LinkedAccount?>((ref, account) => account?.focused ?? false);

class _FocusedTile extends HookWidget {
  const _FocusedTile({Key? key, required this.account}) : super(key: key);
  final LinkedAccount? account;

  @override
  Widget build(BuildContext context) {
    final isFocused = useProvider(focusedProvider(account)).state;
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: 'Focused'.text.base.bold.make(),
      subtitle:
          'Add this to focus mode accounts. This account Will be available when focused mode is active.'
              .text
              .sm
              .color(context.adaptive75)
              .make()
              .pOnly(top: 4),
      value: isFocused,
      onChanged: (value) {
        context.read(focusedProvider(account)).state = value;
      },
    );
  }
}

final notifyFollowersProvider =
    StateProvider.family<bool, LinkedAccount?>((ref, account) => account?.notify ?? true);

class _NotifyFollowersTile extends HookWidget {
  const _NotifyFollowersTile({Key? key, required this.account}) : super(key: key);
  final LinkedAccount? account;
  @override
  Widget build(BuildContext context) {
    final notify = useProvider(notifyFollowersProvider(account)).state;

    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: 'Notify Followers'.text.base.bold.make(),
      subtitle:
          'This will send a notification to your followers that you’ve added this account to your profile.'
              .text
              .sm
              .color(context.adaptive75)
              .make()
              .pOnly(top: 4),
      value: notify,
      onChanged: (value) {
        context.read(notifyFollowersProvider(account)).state = value;
      },
    );
  }
}

final isHiddenProvider =
    StateProvider.family<bool, LinkedAccount?>((ref, account) => account?.hidden ?? false);

class _HiddenTile extends HookWidget {
  const _HiddenTile({Key? key, required this.account}) : super(key: key);
  final LinkedAccount? account;
  @override
  Widget build(BuildContext context) {
    final isHidden = useProvider(isHiddenProvider(account)).state;

    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: 'Hidden'.text.base.bold.make(),
      subtitle:
          'Hidden accounts will not be shown on your Homepage, but still can be added to cards Or shared.'
              .text
              .sm
              .color(context.adaptive75)
              .make()
              .pOnly(top: 4),
      value: isHidden,
      onChanged: (value) {
        context.read(isHiddenProvider(account)).state = value;
      },
    );
  }
}

//FACEBOOK
// (?:(?:http|https):\/\/)?(?:www.)?facebook.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?
// INSTAGRAM
// (?:(?:http|https):\/\/)?(?:www\.)?(?:instagram\.com|instagr\.am)\/([A-Za-z0-9-_\.]+)

//TIKTOK
