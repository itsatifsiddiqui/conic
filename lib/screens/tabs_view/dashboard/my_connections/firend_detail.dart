import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/app_user.dart';
import '../../../../providers/app_user_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../res/res.dart';
import '../../../../widgets/accounts_builder.dart';
import '../../my_accounts/my_accounts_tab.dart';

class FriendDetailScreen extends StatelessWidget {
  const FriendDetailScreen({
    Key? key,
    required this.friend,
    required this.fromFollowing,
  }) : super(key: key);
  final AppUser friend;
  final bool fromFollowing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: '@${friend.username}'.text.xl.color(context.adaptive).make(),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(child: "${friend.name}'s Accounts".text.xl2.semiBold.tight.make()),
                  'Tap on account to open.'.text.sm.color(context.adaptive75).make(),
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
          ),
          16.heightBox,
          LinkedAccountsBuilder(
            accounts: friend.linkedAccounts ?? [],
            longPressEnabled: false,
          )
        ],
      ).p16().scrollVertical(),
    );
  }
}
