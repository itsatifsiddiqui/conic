import 'package:conic/models/app_user.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/widgets/adaptive_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../res/res.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Notifications'.text.semiBold.color(context.adaptive).make(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Divider(height: 0, color: context.adaptive12),
          _FollowRequests(),
          Divider(height: 0, color: context.adaptive12),
        ],
      ),
    );
  }
}

final followRequestsProvider = StreamProvider<List<AppUser>>((ref) {
  final userId = ref.watch(appUserProvider)?.userId;
  if (userId == null) return Stream.value(<AppUser>[]);
  return ref.read(firestoreProvider).getFollowRequests(userId);
});

class _FollowRequests extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: 'Folow Requests'.text.semiBold.make(),
      trailing: SizedBox(
        child: useProvider(followRequestsProvider).when(
          data: (requests) {
            final requestsLength = requests.length;
            if (requestsLength == 0) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.primaryColor,
              ),
              child: requests.length.toString().text.bold.color(Colors.white).make(),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, s) => ''.text.make(),
        ),
      ),
    );
  }
}
