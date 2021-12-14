import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conic/models/card_model.dart';
import 'package:conic/screens/tabs_view/my_cards/my_cards_tab.dart';
import 'package:conic/widgets/adaptive_progress_indicator.dart';
import 'package:conic/widgets/error_widet.dart';
import 'package:conic/widgets/info_widget.dart';
import 'package:conic/widgets/medias_builder.dart';
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
        // actions: [
        //   // RequestStatusButton(
        //   //   currentUserId: currentUserId,
        //   //   requestedUserId: friend.userId!,
        //   // ).p8()
        // ],
      ),
      body: Column(
        children: [
          24.heightBox,
          if (friend.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: friend.image ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: kImagePlaceHodler,
              ),
            )
          else
            CircleAvatar(
              backgroundColor: context.adaptive12,
              maxRadius: 48,
              child: Icon(
                Icons.person,
                size: 42,
                color: context.adaptive54,
              ),
            ),
          16.heightBox,
          if (friend.name != null) friend.name!.firstLetterUpperCase().text.xl.make(),
          RequestStatusButton(
            currentUserId: currentUserId,
            requestedUserId: friend.userId!,
          ).p8(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      child: "${friend.name!.firstLetterUpperCase()}'s Accounts"
                          .text
                          .xl2
                          .semiBold
                          .tight
                          .make()),
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
          12.heightBox,
          Divider(height: 0, color: context.adaptive12),
          _SaveContactTile(friend: friend),
          Divider(height: 0, color: context.adaptive12),
          16.heightBox,
          AccountsMediaAndCardsBuilder(friend: friend),
          // LinkedAccountsBuilder(
          //   accounts: friend.linkedAccounts ?? [],
          //   longPressEnabled: false,
          // ).px16()
        ],
      ).py16().scrollVertical(),
    );
  }
}

class _SaveContactTile extends StatelessWidget {
  final AppUser friend;
  const _SaveContactTile({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            if (whatsappNumber != null) Item(label: 'Whatsapp', value: whatsappNumber.enteredLink),
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
    );
  }
}

class AccountsMediaAndCardsBuilder extends HookWidget {
  final AppUser friend;
  const AccountsMediaAndCardsBuilder({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 3);
    final index = useState<int>(0);
    return Column(
      children: [
        TabBar(
          controller: controller,
          onTap: (value) => index.value = value,
          tabs: [
            Tab(text: "Accounts"),
            Tab(text: "Media"),
            Tab(text: "Cards"),
          ],
        ),
        [
          LinkedAccountsBuilder(accounts: friend.linkedAccounts ?? [], friend: friend),
          MyMediasBuilder(
            medias: (friend.linkedMedias ?? [])
                .sortedByNum((element) => element.timestamp!)
                .reversed
                .toList(),
            isFriend: true,
          ),
          _CardsListBuilder(friend: friend),
        ].elementAt(index.value).p12()
      ],
    );
  }
}

final friendCardsProvider = StreamProvider.autoDispose.family<List<CardModel>, String>((ref, id) {
  return ref.watch(firestoreProvider).getFriendCards(id: id);
});

class _CardsListBuilder extends HookWidget {
  final AppUser friend;
  const _CardsListBuilder({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(friendCardsProvider(friend.userId!)).when(
      data: (cards) {
        if (cards.isEmpty) {
          return InfoWidget(text: "No Cards").pOnly(top: 32);
        }

        return Column(
            children: cards.map((card) {
          return CardDisplayWidget(
            card: card,
            size: MediaQuery.of(context).size,
            fromFriend: true,
          );
        }).toList());
      },
      loading: () => AdaptiveProgressIndicator().pOnly(top: 32),
      error: (e, s) => StreamErrorWidget(error: e.toString()).pOnly(top: 32),
    );
  }
}
