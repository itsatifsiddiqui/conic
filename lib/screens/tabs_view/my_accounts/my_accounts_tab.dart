import 'package:conic/screens/tabs_view/dashboard/my_profile/my_profile_screen.dart';
import 'package:conic/widgets/medias_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/linked_account.dart';
import '../../../providers/app_user_provider.dart';
import '../../../providers/firebase_storage_provider.dart';
import '../../../providers/firestore_provider.dart';
import '../../../res/res.dart';
import '../../../widgets/accounts_builder.dart';
import '../../../widgets/context_action.dart';
import '../../../widgets/no_accounts_widget.dart';
import '../../add_account/account_form_screen.dart';
import '../../add_account/add_new_account_screen.dart';
import 'add_media_sheet.dart';
// final businessModeProvider = StateProvider<bool>((ref) => false);
final isListModeProvider = StateProvider<bool>((ref) {
  return ref.watch(appUserProvider)!.gridMode ?? true;
});

final isFocusedModeProvider = StateProvider<bool>((ref) {
  return ref.watch(appUserProvider)!.focusedMode ?? false;
});
final queryProvider = StateProvider<String>((ref) => '');

///Listen to [queryProvider] and return filtered results
final filteredAccountsStateProvider = StateProvider<List<LinkedAccount>>((ref) {
  final query = ref.watch(queryProvider).state.trim().toLowerCase();
  final allAccounts = ref.watch(appUserProvider)!.linkedAccounts ?? [];
  if (query.isEmpty) return allAccounts;
  return allAccounts.where((element) => element.name.toLowerCase().contains(query)).toList();
});

class MyAccountsTab extends HookWidget {
  const MyAccountsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: 'My Accounts'.text.semiBold.color(context.adaptive).make(),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.help_outline_rounded),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HideModeBuilder(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Greetings(),
              12.heightBox,
              CupertinoSearchTextField(
                borderRadius: BorderRadius.circular(kBorderRadius),
                placeholder: 'Search account',
                prefixInsets: const EdgeInsets.all(8),
                style: TextStyle(color: context.adaptive),
                onChanged: (value) {
                  context.read(queryProvider).state = value;
                },
              ),
              20.heightBox,
              const _MyAccountsTextRow(),
              24.heightBox,
              _MyAccountsBuilder(),
              24.heightBox,
              const _MyMediasRow(),
              8.heightBox,
              HookBuilder(builder: (context) {
                final medias = useProvider(appUserProvider.select((value) => value!.linkedMedias))!
                    .sortedByNum((element) => element.timestamp!)
                    .reversed
                    .toList();
                return MyMediasBuilder(medias: medias);
              }),
              32.heightBox,
            ],
          ).px16().scrollVertical().expand(),
        ],
      ),
    );
  }
}

class _MyAccountsTextRow extends StatelessWidget {
  const _MyAccountsTextRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'My Accounts'.text.xl2.semiBold.tight.make()),
            'Long press for more options.'.text.sm.color(context.adaptive75).make(),
          ],
        ).expand(),
        HookBuilder(
          builder: (context) {
            final isListMode = useProvider(isListModeProvider).state;
            return IconButton(
              icon: Icon(
                isListMode ? Icons.grid_view : Icons.list_alt_sharp,
                color: context.primaryColor,
              ),
              onPressed: () {
                context.read(appUserProvider.notifier).updateListMode();
                context.read(firestoreProvider).updateUser();
              },
            );
          },
        )
      ],
    );
  }
}

class _Greetings extends HookWidget {
  const _Greetings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = useProvider(appUserProvider.select((value) => value?.name ?? 'Conic user'));
    final isFocusedMode = useProvider(isFocusedModeProvider).state;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'Hi, $name'.text.xl3.extraBold.tight.make()),
            // 4.heightBox,
            // 'View My Profile'.text.base.color(context.adaptive75).make(),
          ],
        ).expand(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoSwitch(
              activeColor: context.primaryColor,
              value: isFocusedMode,
              onChanged: (value) {
                context.read(appUserProvider.notifier).updateFocusedMode(value);
                context.read(firestoreProvider).updateUser();
              },
            ),
            4.heightBox,
            '${isFocusedMode ? "Disable" : "Enable"} Focused Mode'
                .text
                .xs
                .color(context.adaptive87)
                .make(),
          ],
        )
      ],
    ).py8();
  }
}

class _MyAccountsBuilder extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accounts = useProvider(filteredAccountsStateProvider).state;
    final isFocusedMode = useProvider(isFocusedModeProvider).state;

    if (accounts.isEmpty) {
      return const NoAccountsWidget();
    }

    final filteredAccounts =
        isFocusedMode ? accounts.where((element) => element.focused).toList() : accounts;

    return LinkedAccountsBuilder(accounts: filteredAccounts, friend: null);
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
            Clipboard.setData(ClipboardData(text: linkedAccount.fullLink));
            VxToast.show(context, msg: 'Link Copied', showTime: 1000, bgColor: Theme.of(context).scaffoldBackgroundColor);
          },
          trailingIcon: Icons.content_copy_outlined,
          child: const Text('Copy'),
        ),
        ContextActionWidget(
          onPressed: () {
            kOpenLink(linkedAccount.fullLink!);
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

  void onAccountTap(LinkedAccount e) {
    kOpenLink(e.fullLink!);
  }
}

class _MyMediasRow extends HookWidget {
  const _MyMediasRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useProvider(firebaseStorageProvider.select((value) => value.isLoading));

    return Column(
      children: [
        Row(
          children: [
            'My Medias'.text.xl2.semiBold.make().expand(),
            HookBuilder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.add,
                    color: context.primaryColor,
                  ),
                  onPressed: () {
                    AddMediaSheet.openMediaSheet(context);
                  },
                );
              },
            )
          ],
        ),
        if (isLoading)
          const LinearProgressIndicator(
            minHeight: 2,
          ).scale(scaleValue: 2)
      ],
    );
  }
}

class _HideModeBuilder extends HookWidget {
  const _HideModeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hidden = useProvider(appUserProvider)?.hiddenMode ?? false;
    if (hidden) {
      return GestureDetector(
        onTap: () {
          Get.to<void>(() => const MyProfileScreen());
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: context.primaryColor,
          child: Row(
            children: [
              'Hide Mode is enabled'.text.color(Colors.white).make().expand(),
              const Icon(Icons.info_outline, color: Colors.white)
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
