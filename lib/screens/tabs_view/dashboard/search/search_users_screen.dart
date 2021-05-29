import 'dart:async';

import 'package:conic/models/app_user.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/res/debouncer.dart';
import 'package:conic/screens/tabs_view/dashboard/my_connections/firend_detail.dart';
import 'package:conic/screens/tabs_view/dashboard/my_connections/user_list_item.dart';
import 'package:conic/widgets/adaptive_progress_indicator.dart';
import 'package:conic/widgets/error_widet.dart';
import 'package:conic/widgets/info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../res/res.dart';

final queryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchedUserProvider = FutureProvider.autoDispose<AppUser?>((ref) async {
  final userName = ref.watch(queryProvider).state.trim().toLowerCase();

  if (userName.length < 6) {
    return null;
  }
  final completer = Completer<AppUser?>();
  ref.watch(debouncerProvider).run(() async {
    final user = await ref.read(firestoreProvider).searchUserByUsername(userName);
    completer.complete(user);
  });

  return completer.future;
});

class SearchUsersScreen extends HookWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = useProvider(appUserProvider.select((value) => value!.username))!;
    final currentUserId = useProvider(appUserProvider.select((value) => value!.userId))!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Search Profile'.text.xl.color(context.adaptive).make(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.heightBox,
              'Type the username to search.'.text.lg.semiBold.make(),
              16.heightBox,
              CupertinoSearchTextField(
                borderRadius: BorderRadius.circular(kBorderRadius),
                placeholder: 'Search username',
                prefixInsets: const EdgeInsets.all(8),
                style: TextStyle(color: context.adaptive),
                onChanged: (value) {
                  context.read(queryProvider).state = value.trim().toLowerCase();
                },
              ),
              16.heightBox,
            ],
          ).px16(),
          HookBuilder(
            builder: (context) {
              final query = useProvider(queryProvider).state;
              if (query.isEmpty) {
                return const InfoWidget(
                  text: 'Search Profile',
                  subText: 'Fill in the field to search a user.',
                ).px24().expand();
              }
              if (query.length < 6) {
                return const InfoWidget(
                  text: 'User not found',
                  subText: 'No user found, please check the searched username',
                ).px64().expand();
              }

              if (query == username) {
                return const InfoWidget(
                  text: 'Nice Try!',
                  subText: "You don't need to search yourself.",
                ).px64().expand();
              }
              return useProvider(searchedUserProvider).when(
                data: (data) {
                  if (data == null) {
                    return const InfoWidget(
                      text: 'User not found',
                      subText: 'No user found, please check the searched username',
                    ).px64().expand();
                  }
                  return UserListItem(
                    onTap: () {
                      Get.to<void>(
                        () => FriendDetailScreen(
                          friend: data,
                          fromFollowing: false,
                        ),
                      );
                    },
                    image: data.image,
                    username: data.username!,
                    name: data.name!,
                    trailing: SendRequestButton(
                      appUser: data,
                      currentUserId: currentUserId,
                    ),
                  );
                },
                loading: () => const AdaptiveProgressIndicator().expand(),
                error: (e, s) {
                  return StreamErrorWidget(
                    error: e.toString(),
                    onTryAgain: () {
                      context.refresh(searchedUserProvider);
                    },
                  ).expand();
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class SendRequestButton extends StatefulHookWidget {
  const SendRequestButton({
    Key? key,
    required this.appUser,
    required this.currentUserId,
    this.followback = false,
  }) : super(key: key);
  final AppUser appUser;
  final String currentUserId;
  final bool followback;

  @override
  _SendRequestButtonState createState() => _SendRequestButtonState();
}

class _SendRequestButtonState extends State<SendRequestButton> {
  late AppUser otherUser;

  @override
  void initState() {
    super.initState();
    otherUser = widget.appUser;
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final currentUserId = widget.currentUserId;
        final hasRequestSent = (otherUser.followRequestsRecieved ?? []).contains(currentUserId);

        debugPrint('HAS REQUEST SENT $hasRequestSent');

        return OutlinedButton(
          onPressed: () {
            final requests = otherUser.followRequestsRecieved ?? [];
            debugPrint('OLD REQUESTS $requests');
            if (hasRequestSent) {
              requests.remove(currentUserId);
              context.read(firestoreProvider).unSendFollowRequest(otherUser.userId!);
            } else {
              requests.add(currentUserId);
              context.read(firestoreProvider).sendFollowRequest(otherUser.userId!);
            }
            debugPrint('NEW REQUESTS $requests');

            final newUser = otherUser.copyWith(followRequestsRecieved: requests);
            otherUser = newUser;
            setState(() {});
          },
          child: (hasRequestSent
                  ? 'Requested'
                  : widget.followback
                      ? 'Follow Back'
                      : 'Follow')
              .text
              .sm
              .color(context.primaryColor)
              .make(),
        );
      },
    );
  }
}
