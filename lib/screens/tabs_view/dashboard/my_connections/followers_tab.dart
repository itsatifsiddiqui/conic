import 'package:conic/res/platform_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/app_user.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../res/res.dart';
import '../../../../widgets/custom_widgets.dart';
import 'user_list_item.dart';

final followersProvider = StreamProvider<List<AppUser>>((ref) {
  return ref.read(firestoreProvider).getFollowers();
});

class FollowersTab extends HookWidget {
  const FollowersTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return useProvider(followersProvider).when(
      data: (docs) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final user = docs[index];
            return UserListItem(
              onTap: () {},
              image: user.image,
              username: user.username ?? 'username',
              name: user.name ?? 'Name',
              trailing: OutlinedButton(
                onPressed: () async {
                  final result = await showPlatformDialogue(
                    title: 'Remove ${user.name}?',
                    content:
                        Text('Are you sure you want to remove ${user.name} from your followers?'),
                    action1OnTap: true,
                    action1Text: 'Yes',
                    action2OnTap: false,
                    action2Text: 'No',
                  );
                  if (result ?? false) {
                    context.read(firestoreProvider).removeUser(user.userId!);
                  }
                },
                child: 'Remove'.text.sm.color(context.primaryColor).make(),
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
            context.refresh(followersProvider);
          },
        );
      },
    );
  }
}
