import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/app_user.dart';
import '../../../../providers/app_user_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../res/platform_dialogue.dart';
import '../../../../res/res.dart';
import '../../../../widgets/adaptive_progress_indicator.dart';
import '../../../../widgets/error_widet.dart';
import 'firend_detail.dart';
import 'user_list_item.dart';

final peopleIFollowsProvider = StreamProvider<List<AppUser>>((ref) {
  final userId = ref.watch(appUserProvider)?.userId;
  log('Creating Provider', name: 'peopleIFollowsProvider');
  if (userId == null) return Stream.value([]);
  return ref.read(firestoreProvider).getUsersIFollow(userId);
});

class FollowingTab extends HookWidget {
  const FollowingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(peopleIFollowsProvider).when(
      data: (docs) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final user = docs[index];
            return UserListItem(
              onTap: () {
                Get.to<void>(
                  () => FriendDetailScreen(friend: user, fromFollowing: true),
                );
              },
              image: user.image,
              username: user.username ?? 'username',
              name: user.name ?? 'Name',
              trailing: OutlinedButton(
                onPressed: () async {
                  final result = await showPlatformDialogue(
                    title: 'Unfollow ${user.name}?',
                    content: Text('Are you sure you want to unfollow ${user.name}?'),
                    action1OnTap: true,
                    action1Text: 'Yes',
                    action2OnTap: false,
                    action2Text: 'No',
                  );
                  if (result ?? false) {
                    context.read(firestoreProvider).unfollowUser(user.userId!);
                  }
                },
                child: 'Unfollow'.text.sm.color(context.primaryColor).make(),
              ),
            );
          },
        );
      },
      loading: () => const AdaptiveProgressIndicator(),
      error: (e, s) {
        return StreamErrorWidget(
          error: e.toString(),
          onTryAgain: () {
            context.refresh(peopleIFollowsProvider);
          },
        );
      },
    );
  }
}
