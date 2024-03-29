import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conic/models/app_user.dart';
import 'package:conic/widgets/info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/linked_account.dart';
import '../providers/app_user_provider.dart';
import '../providers/firestore_provider.dart';
import '../res/res.dart';
import '../screens/add_account/account_form_screen.dart';
import '../screens/add_account/add_new_account_screen.dart';
import '../screens/tabs_view/my_accounts/my_accounts_tab.dart';
import 'context_action.dart';

class LinkedAccountsBuilder extends StatefulHookWidget {
  const LinkedAccountsBuilder({
    Key? key,
    required this.accounts,
    this.friend,
  }) : super(key: key);
  final List<LinkedAccount> accounts;
  final AppUser? friend;

  @override
  _LinkedAccountsBuilderState createState() => _LinkedAccountsBuilderState();
}

class _LinkedAccountsBuilderState extends State<LinkedAccountsBuilder> {
  @override
  void initState() {
    final focusedModeOn = widget.friend?.focusedMode ?? false;
    if (widget.friend != null && focusedModeOn) {
      final focusedAccount = widget.accounts.where((element) => !element.hidden && element.focused).toList();
      if (focusedAccount.isNotEmpty) {
        final account = focusedAccount.first;
        kOpenLink(account.fullLink!, account.name, true);
        Timer(500.milliseconds, () {
          Navigator.of(context).pop();
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isListMode = useProvider(isListModeProvider).state;
    final hiddenMode = widget.friend?.hiddenMode ?? useProvider(appUserProvider)?.hiddenMode ?? false;
    // final accounts = useProvider(filteredAccountsStateProvider).state;

    final longPressEnabled = widget.friend == null;

    //FILTER ACCOUNTS ONLY FOR FRIENDS SCREEN
    final filteredAccounts =
        widget.accounts.where((e) => (e.hidden && hiddenMode && !longPressEnabled) == false).toList();

    if (filteredAccounts.isEmpty && !longPressEnabled) {
      return InfoWidget(text: "No Accounts").pOnly(top: 32);
    }

    if (isListMode) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: filteredAccounts.map((e) {
          final child = GestureDetector(
            onTap: () => onAccountTap(e, context),
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.adaptive.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    4.widthBox,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: e.image,
                        width: 36,
                        height: 36,
                        placeholder: kImagePlaceHodler,
                      ),
                    ),
                    12.widthBox,
                    (e.title.isEmptyOrNull ? e.name : e.title).text.lg.medium.color(context.adaptive87).make().expand()
                  ],
                ),
              ),
            ),
          );
          if (!longPressEnabled) return child;
          return CupertinoContextMenu(
            previewBuilder: (context, animation, child) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return child!;
                },
                child: AccountImage(url: e.image),
              );
            },
            actions: buildContextActions(context, e),
            child: Opacity(
              opacity: hiddenMode && e.hidden ? 0.54 : 1,
              child: child,
            ),
          );
        }).toList(),
      );
    }
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      children: filteredAccounts.map((e) {
        if (!longPressEnabled) {
          return GestureDetector(
            onTap: () => onAccountTap(e, context),
            child: AccountImage(url: e.image),
          );
        }
        return CupertinoContextMenu(
          actions: buildContextActions(context, e),
          child: GestureDetector(
            onTap: () => onAccountTap(e, context),
            child: Opacity(
              opacity: hiddenMode && e.hidden ? 0.54 : 1,
              child: AccountImage(url: e.image),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> buildContextActions(BuildContext context, LinkedAccount linkedAccount) => [
        ContextActionWidget(
          onPressed: () {
            Navigator.pop(context);
          },
          trailingIcon: Icons.ios_share,
          child: const Text('Share'),
        ),
        ContextActionWidget(
          onPressed: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: linkedAccount.fullLink!));
            VxToast.show(context, msg: 'Link Copied', showTime: 1000, textColor: context.backgroundColor);
          },
          trailingIcon: Icons.content_copy_outlined,
          child: const Text('Copy'),
        ),
        ContextActionWidget(
          onPressed: () {
            kOpenLink(linkedAccount.fullLink!, linkedAccount.name);
            Navigator.pop(context);
          },
          trailingIcon: Icons.open_in_new_outlined,
          child: const Text('Open'),
        ),
        ContextActionWidget(
          onPressed: () {
            Navigator.pop(context);
            final allAccounts = context.read(allAccountsProvider).data!.value;
            final account = allAccounts.whereName(linkedAccount.name);
            debugPrint(account.toString());
            Get.to<void>(
              () => AccountFormScreen(
                account: account,
                linkedAccount: linkedAccount,
              ),
            );
          },
          trailingIcon: Icons.edit_outlined,
          child: const Text('Edit'),
        ),
        ContextActionWidget(
          isDestructiveAction: true,
          trailingIcon: Icons.close,
          onPressed: () {
            context.read(appUserProvider.notifier).removeAccount(linkedAccount);
            context.read(firestoreProvider).updateUser();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ];

  void onAccountTap(LinkedAccount e, BuildContext context) {
    kOpenLink(e.fullLink!, e.name);
    final longPressEnabled = widget.friend == null;

    if (longPressEnabled == false) {
      context.read(firestoreProvider).updateAccountTap(e, widget.friend!);
    }
  }
}

class AccountImage extends StatelessWidget {
  const AccountImage({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 120,
        height: 120,
        placeholder: kImagePlaceHodler,
      ),
    );
  }
}
