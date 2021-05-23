import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/account_model.dart';
import '../../res/res.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/primary_button.dart';

class AccountFormScreen extends HookWidget {
  const AccountFormScreen({
    Key? key,
    required this.account,
  }) : super(key: key);

  final AccountModel account;
  @override
  Widget build(BuildContext context) {
    final fieldController = useTextEditingController();
    final fieldNode = useFocusNode();
    final titleController = useTextEditingController();
    final titleNode = useFocusNode();
    final descriptionController = useTextEditingController();
    final descriptionNode = useFocusNode();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FittedBox(
          child: account.name.text.xl.semiBold.color(context.adaptive).make(),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Column(
            children: [
              16.heightBox,
              _ImageBuilder(account: account),
              16.heightBox,
              FilledTextField(
                focusNode: fieldNode,
                nextNode: titleNode,
                controller: fieldController,
                title: account.field,
                hintText: account.fieldHint,
                textInputAction: TextInputAction.next,
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
              _FocusedTile(),
              8.heightBox,
              _NotifyFollowersTile(),
              8.heightBox,
              _HiddenTile(),
              24.heightBox,
            ],
          ).px24().scrollVertical().expand(),
          PrimaryButton(
            text: 'Add Account',
            onTap: () {},
          ).px24().py16()
        ],
      )),
    );
  }
}

class _ImageBuilder extends StatelessWidget {
  const _ImageBuilder({
    Key? key,
    required this.account,
  }) : super(key: key);

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: account.image,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: account.image,
              width: 0.1.sh,
              height: 0.1.sh,
            ),
          ),
        ),
        8.heightBox,
        'Custom Photo'.text.sm.medium.color(AppColors.link).makeCentered()
      ],
    );
  }
}

final focusedProvider = StateProvider<bool>((ref) => false);

class _FocusedTile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isFocused = useProvider(focusedProvider).state;
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
        context.read(focusedProvider).state = value;
      },
    );
  }
}

final notifyFollowersProvider = StateProvider<bool>((ref) => true);

class _NotifyFollowersTile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notify = useProvider(notifyFollowersProvider).state;

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
        context.read(notifyFollowersProvider).state = value;
      },
    );
  }
}

final isHiddenProvider = StateProvider<bool>((ref) => false);

class _HiddenTile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isHidden = useProvider(isHiddenProvider).state;

    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: 'Focused'.text.base.bold.make(),
      subtitle:
          'Hidden accounts will not be shown on your Homepage, but still can be added to cards Or shared.'
              .text
              .sm
              .color(context.adaptive75)
              .make()
              .pOnly(top: 4),
      value: isHidden,
      onChanged: (value) {
        context.read(isHiddenProvider).state = value;
      },
    );
  }
}
