import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/app_user.dart';
import '../../../../providers/app_user_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../res/res.dart';
import '../../../../widgets/accounts_builder.dart';
import '../../my_accounts/my_accounts_tab.dart';
import '../search/search_users_screen.dart';

class FriendDetailScreen extends HookWidget {
  const FriendDetailScreen({
    Key? key,
    required this.friend,
    required this.fromFollowing,
  }) : super(key: key);
  final AppUser friend;
  final bool fromFollowing;

  @override
  Widget build(BuildContext context) {
    final currentUserId = useProvider(appUserProvider.select((value) => value!.userId!));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: '@${friend.username}'.text.xl.color(context.adaptive).make(),
        actions: [
          RequestStatusButton(
            currentUserId: currentUserId,
            requestedUserId: friend.userId!,
          ).p8()
        ],
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
          ).px16(),
          Divider(height: 0, color: context.adaptive12),
          ListTile(
            selected: true,
            onTap: () async {
              final result = await kCheckAndAskForContactsPermission();
              if (result != true) {
                return;
              }

              final phone = friend.linkedAccounts.phoneNumberOrNull();
              final whatsappNumber = friend.linkedAccounts.whatsappNumberOrNull();

              final linedAccounts = friend.linkedAccounts ?? [];
              final allEmails = [...linedAccounts];
              allEmails.remove(phone);
              allEmails.remove(whatsappNumber);

              final newContact = Contact(
                androidAccountType: AndroidAccountType.other,
                displayName: friend.name,
                givenName: friend.name,
                emails: allEmails.map(
                  (e) => Item(
                    label: e.name,
                    value: e.enteredLink,
                  ),
                ),
                phones: [
                  if (phone != null) Item(label: 'Mobile', value: phone.enteredLink),
                  if (whatsappNumber != null)
                    Item(label: 'Whatsapp', value: whatsappNumber.enteredLink),
                ],
              );
              // log(newContact.toMap().toString());
              // final allContacts = await ContactsService.getContacts(withThumbnails: false);
              final filtered = await ContactsService.getContacts(query: newContact.displayName);
              if (filtered.isEmpty) {
                log('Add First');
                await ContactsService.addContact(newContact);
                log(newContact.toMap().toString());
                VxToast.show(context, msg: 'Contact Added');
                return;
              } else {
                final fullSearch =
                    filtered.where((element) => element.displayName == newContact.displayName);
                if (fullSearch.isEmpty) {
                  await ContactsService.addContact(newContact);
                  log(newContact.toMap().toString());
                  VxToast.show(context, msg: 'Contact Added');
                  return;
                } else {
                  VxToast.show(context, msg: 'Contact Already Exist');
                }
              }
            },
            title: 'Save to my contacts'.text.bold.make(),
            trailing: const Icon(Icons.contact_mail_outlined).pOnly(right: 12),
          ),
          Divider(height: 0, color: context.adaptive12),
          16.heightBox,
          LinkedAccountsBuilder(
            accounts: friend.linkedAccounts ?? [],
            longPressEnabled: false,
          ).px16()
        ],
      ).py16().scrollVertical(),
    );
  }
}
