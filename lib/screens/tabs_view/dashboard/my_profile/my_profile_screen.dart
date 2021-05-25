import 'package:conic/providers/auth_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/res/platform_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/app_user_provider.dart';
import '../../../../res/res.dart';
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
        body: Column(
          children: [
            Column(
              children: [
                24.heightBox,
                FilledTextField(
                  disabled: true,
                  controller: TextEditingController(text: user.username),
                  title: 'Username',
                ),
                12.heightBox,
                FilledTextField(
                  disabled: true,
                  controller: TextEditingController(text: user.email),
                  title: 'Email',
                ),
                12.heightBox,
                FilledTextField(
                  controller: nameController,
                  title: 'Name',
                  suffixIcon: const Icon(
                    Icons.edit,
                    color: AppColors.primaryColor,
                  ),
                ),
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
    );
  }
}
